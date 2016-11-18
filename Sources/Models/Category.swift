import Vapor
import Fluent

final class Category: Model {
    
    static let tableName = "categories"
    
    var id: Node?
    var exists: Bool = false
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        name = try node.extract("name")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "name": name
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
