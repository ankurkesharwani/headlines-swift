import Foundation

/// A data structure that represents a story in GNews.
public class Story : Equatable {
    public var title: String?
    public var description: String?
    public var author: String?
    public var source: String?
    public var publishedAt: Date?
    public var urlString: String?
    
    public init() {
        // Do nothing
    }
    
    public static func == (lhs: Story, rhs: Story) -> Bool {
        return lhs.title == rhs.title && lhs.publishedAt == rhs.publishedAt
    }
}
