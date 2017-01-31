import Vapor
import HTTP

extension ResourceRepresentable {
    
    func getUserFromRequest(request: Request) throws -> User {
        guard let userObject = request.storage["user"] else {
            throw Abort.custom(status: Status.badRequest, message: "Authentication error")
        }
        let user = userObject as! User
        return user
    }
    
}
