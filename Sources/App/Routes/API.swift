import Vapor
import HTTP
import Routing
import Auth
import Cookies
import Foundation

class API: RouteCollection {

    typealias Wrapped = HTTP.Responder

    func build<B: RouteBuilder>(_ builder: B) where B.Value == Wrapped {

        let error = Abort.custom(status: .forbidden, message: "Invalid credentials.")
        let protect = ProtectMiddleware(error: error)

        let api = builder.grouped(APIAuthentication()).grouped(protect).grouped("api")

        api.resource("accounts", APIResource<Account>())
        api.resource("categories", APIResource<Category>())
        api.resource("transactions", APIResource<Transaction>())
    }

}
