import Vapor
import HTTP

extension Request {
    
    func user() throws -> User {
        guard let user = try auth.user() as? User else {
            throw Abort.custom(status: .badRequest, message: "Invalid user type.")
        }
        return user
    }
    
}
