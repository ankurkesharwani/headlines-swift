import Foundation
import ShimCurl

class WebAPIAdapter {
    
    static let shared = WebAPIAdapter()
    
    private init() {
        
        // Initialize curl
        shim_curl_init()
    }
    
    deinit {
        
        // Cleanup
        shim_curl_clean()
    }
    
    func execute(request: WebAPIRequest,
                        successCallback: @escaping ((_ response: WebAPIResponse) -> Void),
                        errorCallback: @escaping ((_ error: Error) -> Void)) {
        var urlString = formUrlByPlacingPathParams(request)
        if let queryString = formQueryString(request) {
            urlString.append("?\(queryString)")
        }
        
        // Step 1:
        //
        //Convert aur URL Strinf which is a Swift string to a null
        // terminated C string.
        let urlStringBuffer = makeCString(swiftString: urlString)
        defer {
            urlStringBuffer.deallocate()
        }
        
        // Step 2:
        //
        // For passing our headers we need to first create an array of C strings.
        // This is done by converting all the header strings into a Swift
        // array of C Strings, and then coverting that Swift array to an array of
        // pointers that can be passed to the C function.
        var headers = [String]()
        if let unwrapedHeaders = request.headers {
            for (key, value) in unwrapedHeaders {
                headers.append("\(key): \(value)")
            }
        }
        var mappedHeadersAsCStrings = headers.map { makeCString(swiftString: $0) }
        let numberOfHeaders = mappedHeadersAsCStrings.count
        var allHeadersBuffer: UnsafeMutableBufferPointer<UnsafeMutablePointer<Int8>?>? = nil
        if numberOfHeaders > 0 {
            allHeadersBuffer = UnsafeMutableBufferPointer<UnsafeMutablePointer<Int8>?>.allocate(capacity: numberOfHeaders)
            for i in 0..<numberOfHeaders {
                allHeadersBuffer?[i] = mappedHeadersAsCStrings[i]
            }
        }
        defer {
            for mappedHeader in mappedHeadersAsCStrings {
                mappedHeader.deallocate()
            }
            
            allHeadersBuffer?.deallocate()
        }
        
        // Step 3:
        //
        // To pass the body Curl expects an array of bytes. In C it is represented
        // by a null terminated C string.
        // So in order to convert our dictionary into a form that can be passed
        // to Curl, we first convert it to a Data and then to a swift String
        // with UTF8 encoding. Finally the Swift string is converted into a C
        // string and passed as body.
        var bodyBuffer: UnsafeMutablePointer<Int8>? = nil
        var numberOfBodyBytes = 0
        if request.bodyParam != nil {
            do {
                if let bodyAsData = try request.requestSerializer.serialize(request: request.bodyParam as AnyObject) {
                    if let bytesAsString = String.init(data: bodyAsData, encoding: .utf8) {
                        bodyBuffer = makeCString(swiftString: bytesAsString)
                        numberOfBodyBytes = strlen(bodyBuffer!)
                    }
                }
            } catch {
                errorCallback(WebAPIAdapterError.requestSerializationError(message: "Request serialization error."))
                
                return
            }
        }
        defer {
            bodyBuffer?.deallocate()
        }
        
        // Step 4:
        // Set the headers. Nothing fancy here.
        var simpleRequest = SimpleHttpRequest()
        var simpleResponse = SimpleHttpResponse()
        simpleRequest.url = urlStringBuffer
        
        switch request.method! {
        case .get:
            simpleRequest.method = GET
        case .post:
            simpleRequest.method = POST
        case .delete:
            simpleRequest.method = DELETE
        case .put:
            simpleRequest.method = PUT
        }
        
        if numberOfHeaders > 0 {
            simpleRequest.headers = allHeadersBuffer?.baseAddress
            simpleRequest.num_headers = Int32(numberOfHeaders)
        }
        
        if numberOfBodyBytes > 0 {
            simpleRequest.bytes = bodyBuffer
            simpleRequest.num_bytes = Int32(numberOfBodyBytes)
        }
        
        // Step 5:
        //
        // Make the request.
        shim_curl_request(&simpleRequest, &simpleResponse)
        
        // Step 6:
        //
        // Get the response. The response may or may not have byte data, in our
        // case it does so we first check how many bytes are returned, these
        // bytes are first stored into a buffer of type Int8 and then converted
        // to Data. The data then can be interpreted as required, in our case
        // converting to a string.
        let responseStatusCode = Int(simpleResponse.status_code)
        var serializedResponse: AnyObject? = nil
        if simpleResponse.num_bytes > 0 {
            let responseBuffer = UnsafeBufferPointer.init(start: simpleResponse.bytes, count: Int(simpleResponse.num_bytes))
            let data = Data.init(buffer: responseBuffer)
            let responseHeadersAsString = String(cString: simpleResponse.headers)
            do {
                serializedResponse = try request.responseSerializer.serialize(data: data)
            } catch {
                errorCallback(WebAPIAdapterError.requestSerializationError(message: "Response serialization error."))
                
                return
            }
        }
        defer {
            simpleResponse.headers.deallocate()
            simpleResponse.bytes.deallocate()
        }
        
        // Step 7:
        //
        // Construct the response and return.
        let response = WebAPIResponse.init(statusCode: responseStatusCode, response: serializedResponse)
        successCallback(response)
    }
    
    private func formUrlByPlacingPathParams(_ request: WebAPIRequest) -> String {
        var thisUrlString = request.urlString
        
        guard request.pathParam != nil else {
            return thisUrlString!
        }
        
        for (key, value) in request.pathParam! {
            thisUrlString = thisUrlString?.replacingOccurrences(of: ":\(key)", with: value)
        }
        
        return thisUrlString!
    }
    
    private func formQueryString(_ request: WebAPIRequest) -> String? {
        guard request.queryParam != nil else {
            return nil
        }
        
        var queryComponents = [String]()
        for (key, value) in request.queryParam! {
            queryComponents.append("\(key)=\(value)")
        }
        
        return queryComponents.joined(separator: "&").addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    }
    
    private func makeCString(swiftString: String) -> UnsafeMutablePointer<Int8> {
        let swiftStringCount = swiftString.utf8.count + 1
        let swiftStringBuffer = UnsafeMutablePointer<Int8>.allocate(capacity: swiftStringCount)
        
        swiftString.withCString { (baseAddress) in
            swiftStringBuffer.initialize(from: baseAddress, count: swiftStringCount)
        }
        
        return swiftStringBuffer
    }
}
