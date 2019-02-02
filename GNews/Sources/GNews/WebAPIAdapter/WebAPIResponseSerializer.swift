import Foundation

protocol WebAPIResponseSerializer {
    static func serialize(data: Data) throws -> AnyObject?
}

class WebAPIResponseJSONSerializer: WebAPIResponseSerializer {
    class func serialize(data: Data) throws -> AnyObject? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] as AnyObject
        } catch {
            throw WebAPIAdapterError.responseSerializationError(message: error.localizedDescription)
        }
    }
}
