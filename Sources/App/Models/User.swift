import Vapor
import Fluent
import Auth

final class User: Model {
    
    var id: Node?
    var exists: Bool = false
    var email: String
    var password: String
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        email = try node.extract("email")
        password = try node.extract("password")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "email": email,
            "password": password
            ])
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("users") { users in
            users.id()
            users.string("email")
            users.string("password")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("users")
    }
    
}

extension User: Auth.User {
    
    static func authenticate(credentials: Credentials) throws -> Auth.User {
        switch credentials {
        case let basicAuth as APIKey:
            guard let user = try User.query().filter("email", basicAuth.id).first() else {
                throw Abort.custom(status: .forbidden, message: "Invalid user.")
            }
            if (user.password != basicAuth.secret) {
                throw Abort.custom(status: .forbidden, message: "Invalid password.")
            }
            return user
        default:
            let type = type(of: credentials)
            throw Abort.custom(status: .forbidden, message: "Unsupported credential type: \(type).")
        }
    }
    
    static func register(credentials: Credentials) throws -> Auth.User {
        throw Abort.custom(status: .internalServerError, message: "Internal error")
    }
    
}
