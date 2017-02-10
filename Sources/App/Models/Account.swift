import Foundation
import Vapor
import Fluent
import HTTP

final class Account: APIModel {

    typealias APIModel = Account
    
    var id: Node?
    var exists: Bool = false
    var name: Valid<NotEmpty>
    var createdAt: Valid<Timestamp>
    var updatedAt: Valid<Timestamp>
    
    //Relationships
    var userId: Node

    init(request: Request) throws {
        self.userId = try request.userId()
        self.createdAt = try Date().timestamp().validated(by: Timestamp())
        self.updatedAt = try Date().timestamp().validated(by: Timestamp())
        self.name = try request.data.extractString("name").validated(by: NotEmpty())
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
    
    func updateWithRequest(request: Request) throws {
        self.name = try request.data.extractString("name").validated(by: NotEmpty())
    }
   
}
