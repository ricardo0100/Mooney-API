import Foundation
import Vapor
import Fluent

class AccountModel: ModelBaseProtocol {
    
    static func tableName() -> String {
        return "accounts"
    }
    
    static func addFieldsToSchema(_ schema: Schema.Creator) throws {
        schema.string("name")
    }
    
}

final class Account: ModelBase<AccountModel> {
    
    var name: Valid<NotEmpty>
    
    init(name: String, userId: Node?) throws {
        self.name = try name.validated(by: NotEmpty())
        try super.init(userId: userId)
    }
    
    required init(node: Node, in context: Context) throws {
        name = try (node.extract("name") as String).validated(by: NotEmpty())
        try super.init(node: node, in: context)
    }
    
    override func customFields() -> [String : NodeRepresentable?] {
        return ["name": name.value]
    }
    
}
