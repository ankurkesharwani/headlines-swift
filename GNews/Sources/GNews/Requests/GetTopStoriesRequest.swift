import Foundation

/// Gets top stories from Google News API
public class GetTopStoriesRequest {
    
    /// Response of the request `GetTopStoriesRequest`
    public class Response {
        
        /// Any error encountered before, during and after making the api call,
        /// will be `nil` if no error is encountered.
        public var error: Error?
        
        /// Fetched stories.
        public var stories: [Story]?
        
        init(from error: Error?) {
            self.error = error
        }
        
        init(from response: WebAPIResponse) {
            let statusCode = response.statusCode
            
            if let jsonBody = response.response  as? JSON {
                if statusCode >= 200 && statusCode < 300 {
                    GetTopHeadlinesResponseParser.update(response: self, from: jsonBody)
                } else {
                    error = WebAPIAdapterError.httpError(statusCode: statusCode, message: jsonBody["message"] as! String)
                }
            }
        }
    }
    
    /// Search query.
    public var query: String?
    
    /// Search category.
    public var category: String?
    
    /// Limit results to a specific country only. Default to `India`.
    public var country: String?
    
    /// Google News API Key
    public var apiKey: String?
    
    public init() {
        // Do nothing
    }
    
    /// Executes the request.
    ///
    /// - Parameter onComplete: Closure to be called after the completion of
    ///   the request.
    public func execute(onComplete: @escaping (Response) -> Void) {
        let req = WebAPIRequest()
        req.urlString = ":server/:version/:service"
        req.method = .get
        
        req.pathParam = [
            "server": "https://newsapi.org",
            "version": "v2",
            "service": "top-headlines"
        ]
        
        req.queryParam = WebAPIRequest.QueryParam()
        req.queryParam?["q"] = query
        req.queryParam?["category"] = category
        req.queryParam?["country"] = country ?? "in"
        req.queryParam?["apiKey"] = apiKey

        req.headers = [
            "Accept": "application/json"
        ]
        
        WebAPIAdapter.shared.execute(request: req, successCallback: { (response) in
            onComplete(Response.init(from: response))
        }) { (error) in
            onComplete(Response.init(from: error))
        }
    }
}

class GetTopHeadlinesResponseParser {
    class func update(response: GetTopStoriesRequest.Response, from json: JSON) {
        do {
            if let articlesJson: [JSON] = try Parser.parse(key: "articles", from: json) {
                var stories = [Story]()
                for articleJson in articlesJson {
                    if let story = StoryParser.getStory(from: articleJson) {
                        stories.append(story)
                    }
                }
                
                if stories.count > 0 {
                    response.stories = stories
                }
            }
        } catch {
            #if DEBUG
                Parser.printError(error)
            #endif
        }
    }
}
