import GNews
import Console

class Application {
    func main() {
        if let command = CommandParser.shared.getCommand() {
            let request = GetTopStoriesRequest()

            // TODO: Set your Google News API key
            request.apiKey = "replace-with-your-own-key"
            request.category = command.category?.rawValue
            request.country = command.country?.rawValue
            request.query = command.query
            request.execute { (response) in
                if response.error != nil {
                    print(response.error ?? "Some error occured.")
                    
                    return
                }
                
                if let stories  = response.stories {
                    for story in stories {
                        self.printStory(story: story)
                    }
                } else {
                    print("There are no stories to show.")
                }
            }
        }
    }
    
    func printStory(story: Story) {
        if let titleString = story.title {
            let titleStringBuffer = makeCString(swiftString: titleString)
            defer {
                titleStringBuffer.deallocate()
            }
            
            Console.console_println(Int32(FG_BOLD_RED.rawValue), titleStringBuffer)
        }
        
        if let descriptionString = story.description {
            let descriptionStringBuffer = makeCString(swiftString: descriptionString)
            defer {
                descriptionStringBuffer.deallocate()
            }
            
            Console.console_println(Int32(FG_BLACK.rawValue), descriptionStringBuffer)
        }
        
        if let linkString = story.urlString {
            let linkStringBuffer = makeCString(swiftString: linkString)
            defer {
                linkStringBuffer.deallocate()
            }
            
            Console.console_println(Int32(FG_BLUE.rawValue), linkStringBuffer)
        }
        
        if let sourceString = story.source {
            let sourceStringBuffer = makeCString(swiftString: sourceString)
            defer {
                sourceStringBuffer.deallocate()
            }
            
            Console.console_println(Int32(FG_BOLD_CYAN.rawValue), sourceStringBuffer)
        }
        
        print()
        print()
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
