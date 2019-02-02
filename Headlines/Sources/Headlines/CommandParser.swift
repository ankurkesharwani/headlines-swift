class CommandParser {
    var args: [String]?
    var argsCount: Int?
    
    static let shared = CommandParser.init()
    
    private init() {
        args = CommandLine.arguments
        argsCount = args?.count
    }
    
    func getCommand() -> Command? {
        guard let args = self.args, let count = argsCount else {
            // Todo: Print help
            
            return nil
        }
        
        let command = Command()
        for var i in 1..<count {
            let arg = args[i]
            
            if arg == "-h" || arg == "--help" {
                print("OVERVIEW: Get top headlines(or search news headlines) from Google News API.")
                print()
                print("USAGE: headlines [options]")
                print()
                print("OPTIONS:")
                print("--region, -r     Select a region/country.")
                print("--category, -c   Select a category.")
                print("--query, -q      Search news headlines based on specific keywork. Must only be used with `-g search` option")
                print()
                print("REGIONS:")
                print("ae, ar, at, au, be, bg, br, ca, ch, cn, co, cu, cz, de, eg, fr, gb, gr, hk, hu, id, ie, il, in, it, jp, kr, lt, lv, ma, mx, my, ng, nl, no, nz, ph, pl, pt, ro, rs, ru, sa, se, sg, si, sk, th, tr, tw, ua, us, ve, za")
                print()
                print("CATEGORIES:")
                print("business, entertainment, general, health, science, sports, technology")
                
                return nil
            } else if arg == "-r" || arg == "--region" {
                i = i + 1
                if i < count {
                    let value = args[i]
                    if let region = Command.Region.init(rawValue: value) {
                        command.country = region
                    } else {
                        print("Error: Invalid input for -r or --region. Accepted values are: [ae, ar, at, au, be, bg, br, ca, ch, cn, co, cu, cz, de, eg, fr, gb, gr, hk, hu, id, ie, il, in, it, jp, kr, lt, lv, ma, mx, my, ng, nl, no, nz, ph, pl, pt, ro, rs, ru, sa, se, sg, si, sk, th, tr, tw, ua, us, ve, za].")
                    }
                } else {
                    print("Error: Expected a value for -r or --region")
                }
            } else if arg == "-c" || arg == "--category" {
                i = i + 1
                if i < count {
                    let value = args[i]
                    if let category = Command.Category.init(rawValue: value) {
                        command.category = category
                    } else {
                        print("Error: Invalid input for -c or --category. Accepted values are: [business, entertainment, general, health, science, sports, technology].")
                    }
                } else {
                    print("Error: Expected a value for -c or --category")
                }
            } else if arg == "-q" || arg == "--query" {
                i = i + 1
                if i < count {
                    command.query = args[i]
                } else {
                    print("Error: Expected a value for -q or --query")
                }
            }
        }
        
        return command
    }
}

