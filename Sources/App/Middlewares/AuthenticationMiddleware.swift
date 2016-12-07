import Foundation
import HTTP
import Vapor

class AuthenticationMiddleware: Middleware {
    
    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        
        guard let authorization = request.headers["Authorization"] else {
            throw Abort.badRequest
        }

        let authorizationHeaderValue = String(authorization.characters.array.dropFirst(6))
        
        guard let decodedData = NSData(base64Encoded: authorizationHeaderValue, options: NSData.Base64DecodingOptions.init(rawValue: 0)) else {
            throw Abort.badRequest
        }
        
        guard let decodedString = NSString(data: decodedData as Data, encoding: String.Encoding.utf8.rawValue) else {
            throw Abort.badRequest
        }
        
        let components = decodedString.components(separatedBy: ":")
        
        let email = components[0]
        let password = components[1]
        
        guard let user = try User.query().filter("email", email).first() else {
            throw Abort.badRequest
        }
        
        if user.password != password {
            throw Abort.badRequest
        }
        
        request.headers["userID"] = user.id!.string!
        
        return try next.respond(to: request)
        
    }
    
}
