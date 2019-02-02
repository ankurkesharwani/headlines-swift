import Foundation

enum WebAPIAdapterError: Error {
    case httpError(statusCode: Int, message: String)
    case error(message: String)
    case noData(message: String)
    case requestSerializationError(message: String)
    case responseSerializationError(message: String)
}

