import Foundation
import Vapor
import Fluent

final class Account: Model {
    
    var id: Node?
    var exists: Bool = false
    var name: Valid<NotEmpty>
    var createdAt: Valid<Timestamp>
    var updatedAt: Valid<Timestamp>

    init(name: String) throws {
        self.name = try name.validated(by: NotEmpty())
        self.createdAt = try Date().timestamp().validated(by: Timestamp())
        self.updatedAt = try Date().timestamp().validated(by: Timestamp())
    }

    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        name = try (node.extract("name") as String).validated(by: NotEmpty())
        createdAt = try (node.extract("createdAt") as String).validated(by: Timestamp())
        updatedAt = try (node.extract("updatedAt") as String).validated(by: Timestamp())
    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "name": name.value,
            "createdAt": createdAt.value,
            "updatedAt": updatedAt.value
        ])
    }

    static func prepare(_ database: Database) throws {
        try database.create("accounts") { accounts in
            accounts.id()
            accounts.string("name")
            accounts.string("createdAt")
            accounts.string("updatedAt")
        }
    }

    static func revert(_ database: Database) throws {
        try database.delete("accounts")
    }
    
}
