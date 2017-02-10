import Vapor
import HTTP

extension Request {
    
    func user() throws -> User {
        guard let user = try auth.user() as? User else {
            throw Abort.custom(status: .badRequest, message: "Invalid user type.")
        }
        return user
    }
    
    func userId() throws -> Node {
        guard let userId = try self.user().id else {
            throw Abort.serverError
        }
        
        return userId
    }
    
}
