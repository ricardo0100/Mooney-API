import Foundation
import Vapor
import Fluent

final class Category: Model {
    
    var id: Node?
    var exists: Bool = false
    var name: Valid<NotEmpty>
    var createdAt: Valid<Timestamp>
    var updatedAt: Valid<Timestamp>
    
    public static var entity: String {
        return "categories"
    }
    
    //Relationships
    var userId: Node?
    
    init(name: String, userId: Node?) throws {
        self.name = try name.validated(by: NotEmpty())
        self.createdAt = try Date().timestamp().validated(by: Timestamp())
        self.updatedAt = try Date().timestamp().validated(by: Timestamp())
        self.userId = userId
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        name = try (node.extract("name") as String).validated(by: NotEmpty())
        createdAt = try (node.extract("createdAt") as String).validated(by: Timestamp())
        updatedAt = try (node.extract("updatedAt") as String).validated(by: Timestamp())
        userId = try (node.extract("user_id") as Node)
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "name": name.value,
            "createdAt": createdAt.value,
            "updatedAt": updatedAt.value,
            "user_id": userId
            ])
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("categories") { category in
            category.id()
            category.string("name")
            category.string("createdAt")
            category.string("updatedAt")
            category.parent(User.self, optional: false)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("categories")
    }
    
    func user() throws -> Parent<User> {
        return try parent(userId)
    }
    
}
