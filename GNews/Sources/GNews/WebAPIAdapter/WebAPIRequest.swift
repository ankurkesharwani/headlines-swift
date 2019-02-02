import Foundation

class WebAPIRequest {
    typealias QueryParam = [String: String]
    typealias PathParam = [String: String]
    typealias BodyParam = [String: Any]
    typealias Headers = [String: String]
    
    enum RequestMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    var method: RequestMethod!
    var urlString: String!
    var queryParam: QueryParam?
    var pathParam: PathParam?
    var bodyParam: BodyParam?
    var headers: Headers?
    var requestSerializer: WebAPIRequestSerializer.Type!
    var responseSerializer: WebAPIResponseSerializer.Type!
    
    init() {
        requestSerializer = WebAPIRequestJSONSerializer.self
        responseSerializer  = WebAPIResponseJSONSerializer.self
    }
}
