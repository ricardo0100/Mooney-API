import Vapor
import Fluent

final class Account: Model {
    
    static let tableName = "accounts"

    var id: Node?
    var exists: Bool = false
    var name: Valid<NotEmpty>

    init(name: String) throws {
        self.name = try name.validated(by: NotEmpty())
    }

    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        name = try (node.extract("name") as String).validated(by: NotEmpty())
    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "name": name.value
        ])
    }

    static func prepare(_ database: Database) throws {
        try database.create(self.tableName) { accounts in
            accounts.id()
            accounts.string("name")
        }
    }

    static func revert(_ database: Database) throws {
        try database.delete(self.tableName)
    }

}
