import Vapor
import HTTP
import Routing

class API: RouteCollection {
    
    typealias Wrapped = HTTP.Responder

    func build<B: RouteBuilder>(_ builder: B) where B.Value == Wrapped {
        let api = builder.grouped(AuthenticationMiddleware()).grouped("api")
        
        let accountsController = AccountsController()
        api.resource("accounts", accountsController)
        
//        let categoriesController = Cate
    }
    
}
