import Foundation
import Vapor
import Fluent
import HTTP

enum TransactionTypes: String {
    case Debit
    case Credit
}

final class Transaction: APIModel {
    
    typealias APIModel = Transaction
    
    var id: Node?
    var exists: Bool = false
    var createdAt: Valid<Timestamp>
    var updatedAt: Valid<Timestamp>
    
    var name: Valid<NotEmpty>
    var type: Valid<TransactionType>
    var value: Valid<NotNegative>
    
    //Relationships
    var userId: Node
    var categoryId: Node
    var accountId: Node
    
    init(request: Request) throws {
        let user = try request.user()
        self.userId = user.id!
        self.createdAt = try Date().timestamp().validated(by: Timestamp())
        self.updatedAt = try Date().timestamp().validated(by: Timestamp())
        
        self.name = try request.data.extractString("name").validated(by: NotEmpty())
        self.type = try request.data.extractString("type").validated(by: TransactionType())
        self.value = try request.data.extractDouble("value").validated(by: NotNegative())
        
        self.categoryId = try Node(request.data.extractInt("category_id").validated(by: UserOwns<Category>(user: user)).value)
        self.accountId = try Node(request.data.extractInt("account_id").validated(by: UserOwns<Account>(user: user)).value)
    }
    
    init(node: Node, in context: Context) throws {
        userId = try node.extract("user_id")
        
        id = try node.extract("id")
        createdAt = try (node.extract("createdAt") as String).validated(by: Timestamp())
        updatedAt = try (node.extract("updatedAt") as String).validated(by: Timestamp())
        
        name = try (node.extract("name") as String).validated(by: NotEmpty())
        type = try (node.extract("type") as String).validated(by: TransactionType())
        value = try (node.extract("value") as Double).validated(by: NotNegative())
        
        categoryId = try node.extract("category_id")
        accountId = try node.extract("account_id")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "createdAt": createdAt.value,
            "updatedAt": updatedAt.value,
            "name": name.value,
            "type": type.value,
            "value": value.value,
            "user_id": userId,
            "category_id": categoryId,
            "account_id": accountId
            ])
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("transactions") { accounts in
            accounts.id()
            accounts.string("createdAt")
            accounts.string("updatedAt")
            accounts.string("name")
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
    
    func updateWithRequest(request: Request) throws {
        let user = try request.user()
        
        self.name = try request.data.extractString("name").validated(by: NotEmpty())
        self.type = try request.data.extractString("type").validated(by: TransactionType())
        self.value = try request.data.extractDouble("value").validated(by: NotNegative())
        
        self.categoryId = try Node(request.data.extractInt("category_id").validated(by: UserOwns<Category>(user: user)).value)
        self.accountId = try Node(request.data.extractInt("account_id").validated(by: UserOwns<Account>(user: user)).value)
    }
    
}
