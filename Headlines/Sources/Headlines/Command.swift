import Foundation

class Command {
    enum Region: String {
        case ae, ar, at, au, be, bg, br, ca, ch, cn, co, cu, cz, de, eg, fr, gb, gr, hk, hu, id, ie, il, `in`, it, jp, kr, lt, lv, ma, mx, my, ng, nl, no, nz, ph, pl, pt, ro, rs, ru, sa, se, sg, si, sk, th, tr, tw, ua, us, ve, za
    }
    
    enum Category: String {
        case business, entertainment, general, health, science, sports, technology
    }
    
    var category: Category? = nil
    var query: String? = nil
    var country: Region? = nil
}
