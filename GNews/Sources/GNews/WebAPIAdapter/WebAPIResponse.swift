import Foundation

class WebAPIResponse {
    let statusCode: Int
    var response: AnyObject?
    
    init(statusCode: Int, response: AnyObject?) {
        self.statusCode = statusCode
        self.response = response
    }
}
