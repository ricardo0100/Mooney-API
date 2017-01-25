import Foundation
import Vapor
import Fluent

final class Transaction: Model {
    
    enum TransactionTypes: String {
        case Debit = "Debit"
        case Credit = "Credit"
        
        static func fromString(_ string: String) -> TransactionTypes {
            switch string {
            case Credit.rawValue:
                return Credit
            default:
                return Debit
            }
        }
    }
    
    var id: Node?
    var exists: Bool = false
    var name: Valid<NotEmpty>
    var createdAt: Valid<Timestamp>
    var updatedAt: Valid<Timestamp>
    var type: String
    var value: Double
    
    init(name: String) throws {
        self.name = try name.validated(by: NotEmpty())
        self.createdAt = try Date().timestamp().validated(by: Timestamp())
        self.updatedAt = try Date().timestamp().validated(by: Timestamp())
        self.type = TransactionTypes.Debit.rawValue
        self.value = 0.0
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        name = try (node.extract("name") as String).validated(by: NotEmpty())
        createdAt = try (node.extract("createdAt") as String).validated(by: Timestamp())
        updatedAt = try (node.extract("updatedAt") as String).validated(by: Timestamp())
        type = try (node.extract("type") as String)
        value = try (node.extract("value") as Double)
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "name": name.value,
            "createdAt": createdAt.value,
            "updatedAt": updatedAt.value,
            "type": type,
            "value": value
            ])
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("transactions") { accounts in
            accounts.id()
            accounts.string("name")
            accounts.string("createdAt")
            accounts.string("updatedAt")
            accounts.string("type")
            accounts.double("value")
            accounts.parent(User.self, optional: false)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("transactions")
    }
    
}
