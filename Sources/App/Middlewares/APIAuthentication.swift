import Foundation
import HTTP
import Vapor

class APIAuthentication: Middleware {
    
    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        guard let credentials = request.auth.header?.basic else {
            throw Abort.custom(status: Status.forbidden, message: "Authentication error")
        }
        
        try request.auth.login(credentials, persist: false)
        
        return try next.respond(to: request)
    }
    
}
