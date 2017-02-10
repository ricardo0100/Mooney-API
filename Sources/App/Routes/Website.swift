import Vapor
import HTTP
import Routing

class Website: RouteCollection {
    
    typealias Wrapped = HTTP.Responder
    
    func build<B: RouteBuilder>(_ builder: B) where B.Value == Wrapped {
        let website = builder.grouped("")
        
        website.get { request in
//            return "👷🏼 Under Construction 🛠"
            
            return try JSON(node: User.query().first())
//            return try drop.view.make("index.html")
        }
        
    }
}
