import Foundation


/// Maps a story json to a `Story` object.
class StoryParser {

    /// Gets a new instance of `Story` from a given `JSON`.
    ///
    /// - Parameter json: Json represnetation of a story.
    /// - Returns: A well formed `Story` instance.
    class func getStory(from json: JSON) -> Story? {
        let story = Story()
        update(story: story, from: json)
        
        return story
    }
    
    /// Updates a `Story` instance will a partial `JSON`.
    ///
    /// - Parameters:
    ///   - story: Instance of the `Story` that needs updating.
    ///   - json: `JSON` representation of the story.
    class func update(story: Story, from json: JSON) {
        do {
            story.title = try Parser.parse(key: "title", from: json)
        } catch {
            #if DEBUG
            Parser.printError(error)
            #endif
        }
        
        do {
            story.description = try Parser.parse(key: "description", from: json)
        } catch {
            #if DEBUG
            Parser.printError(error)
            #endif
        }
        
        do {
            story.publishedAt = try Parser.toDate(dateString: Parser.parse(key: "publishedAt", from: json), format: "yyyy-MM-dd'T'HH:mm:ss'Z'")
        } catch {
            #if DEBUG
            Parser.printError(error)
            #endif
        }
        
        do {
            story.urlString = try Parser.parse(key: "url", from: json)
        } catch {
            #if DEBUG
            Parser.printError(error)
            #endif
        }
        
        do {
            story.author = try Parser.parse(key: "author", from: json)
        } catch {
            #if DEBUG
            Parser.printError(error)
            #endif
        }
        
        do {
            if let sourceJson: JSON = try Parser.parse(key: "source", from: json) {
                story.source = try Parser.parse(key: "name", from: sourceJson)
            }
        } catch {
            #if DEBUG
            Parser.printError(error)
            #endif
        }
    }
}
