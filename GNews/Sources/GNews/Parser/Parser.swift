import Foundation

/// Declare a new data type to represent `JSON` dictionary after serialization from `String`
typealias JSON = [String: Any]

enum ParserError: Error {
    case missing(String)
    case invalid(String, Any)
}

class Parser {
    
    /// Parses a key from a dictionary and returns the value.
    ///
    /// - Parameters:
    ///   - key: The key to parse in the JSON
    ///   - json: A dictionary of type [String: Any]
    /// - Returns: The parsed value
    /// - Throws: Throws exception when key is not present or data type mismatch occours
    class func parse<T>(key: String, from json: JSON) throws -> T? {
        let keyExists = json[key] != nil
        if keyExists == false {
            throw ParserError.missing("\(String(describing: self)): Missing Key: \(key)")
        }
        
        if json[key] is NSNull {
            return nil
        }
        
        if let value = json[key] as? T {
            return value
        } else {
            throw ParserError.invalid("\(String(describing: self)): Invalid value for key: \(key)", json[key]!)
        }
    }
    
    // MARK: Transformations
    
    class func toDate(dateString: String?) -> Date? {
        guard dateString != nil else {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.date(from: dateString!)
    }
    
    class func toDate(dateString: String?, format: String) -> Date? {
        guard dateString != nil else {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.date(from: dateString!)
    }
    
    class func toString(intValue: Int?) -> String? {
        guard intValue != nil else {
            return nil
        }
        
        return String(intValue!)
    }
    
    class func toString(doubleValue: Double?) -> String? {
        guard doubleValue != nil else {
            return nil
        }
        
        return String(doubleValue!)
    }
    
    class func toString(floatValue: Float?) -> String? {
        guard floatValue != nil else {
            return nil
        }
        
        return String(floatValue!)
    }
    
    class func toInt(intString: String?) -> Int? {
        guard intString != nil else {
            return nil
        }
        
        return Int(intString!)
    }
    
    class func toFloat(floatString: String?) -> Float? {
        guard floatString != nil else {
            return nil
        }
        
        return Float(floatString!)
    }
    
    class func toDouble(doubleString: String?) -> Double? {
        guard doubleString != nil else {
            return nil
        }
        
        return Double(doubleString!)
    }
    
    class func toBool(boolString: String?) -> Bool? {
        guard boolString != nil else {
            return nil
        }
        
        return Bool(boolString!)
    }
    
    class func toNil(string: String?) -> String? {
        if string?.count == 0 {
            return nil
        }
        return string
    }
    
    // MARK: Helpers
    
    class func printError(_ error: Error) {
        if let parseError = error as? ParserError {
            switch parseError {
            case .invalid(let message, let value):
                print("\(message) \(value)")
            case .missing( _):
                return
            }
        } else {
            print(error)
        }
    }
}

