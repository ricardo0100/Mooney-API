import Vapor
import Fluent

final class User: Model {
    
    static let tableName = "users"
    
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
        try database.create(self.tableName) { users in
            users.id()
            users.string("email")
            users.string("password")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self.tableName)
    }
    
}
