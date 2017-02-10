import Foundation
import Vapor
import Fluent

enum TransactionTypes: String {
    case Debit
    case Credit
}

final class Transaction: Model {
    
    var id: Node?
    var exists: Bool = false
    var name: Valid<NotEmpty>
    var createdAt: Valid<Timestamp>
    var updatedAt: Valid<Timestamp>
    var type: String
    var value: Double
    
    //Relationships
    var userId: Node?
    var categoryId: Node?
    var accountId: Node?
    
    init(name: String, userId: Node?, categoryId: Node?, accountId: Node?) throws {
        self.name = try name.validated(by: NotEmpty())
        self.createdAt = try Date().timestamp().validated(by: Timestamp())
        self.updatedAt = try Date().timestamp().validated(by: Timestamp())
        self.type = TransactionTypes.Debit.rawValue
        self.value = 0.0
        self.userId = userId
        self.categoryId = categoryId
        self.accountId = accountId
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        name = try (node.extract("name") as String).validated(by: NotEmpty())
        createdAt = try (node.extract("createdAt") as String).validated(by: Timestamp())
        updatedAt = try (node.extract("updatedAt") as String).validated(by: Timestamp())
        type = try (node.extract("type") as String)
        value = try (node.extract("value") as Double)
        userId = try node.extract("user_id")
        categoryId = try node.extract("category_id")
        accountId = try node.extract("account_id")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "name": name.value,
            "createdAt": createdAt.value,
            "updatedAt": updatedAt.value,
            "type": type,
            "value": value,
            "user_id": userId,
            "category_id": categoryId,
            "account_id": accountId
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
            accounts.parent(Category.self, optional: false)
            accounts.parent(Account.self, optional: false)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("transactions")
    }
    
}
