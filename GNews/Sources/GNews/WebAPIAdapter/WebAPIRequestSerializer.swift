import Foundation

protocol WebAPIRequestSerializer {
    static func serialize(request: AnyObject) throws -> Data?
}

class WebAPIRequestJSONSerializer: WebAPIRequestSerializer {
    class func serialize(request: AnyObject) throws -> Data? {
        do {
            return try JSONSerialization.data(withJSONObject: request, options: .prettyPrinted)
        } catch {
            throw WebAPIAdapterError.requestSerializationError(message: error.localizedDescription)
        }
    }
}

class WebAPIRequestURLEncodedSerializer: WebAPIRequestSerializer {
    class func serialize(request: AnyObject) throws -> Data? {
        if request is [String: String] {
            var components = [String]()
            
            for (key, value) in request as! [String: String] {
                components.append("\(key)=\(value)")
            }
            
            return components.joined(separator: "&").data(using: .utf8)
        }
        
        return nil
    }
}
