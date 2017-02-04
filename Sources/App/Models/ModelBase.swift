
import Foundation
import Vapor
import HTTP
import Fluent

protocol ModelBaseProtocol {
    static func tableName() -> String
    static func addFieldsToSchema(_ schema: Schema.Creator) throws
}

class ModelBase<T: ModelBaseProtocol>: Model {
    
    //Fields
    var id: Node?
    var createdAt: Valid<Timestamp>
    var updatedAt: Valid<Timestamp>
    
    //Relationships
    var userId: Node?
    
    init(userId: Node?) throws {
        self.userId = userId
        self.createdAt = try Date().timestamp().validated(by: Timestamp())
        self.updatedAt = try Date().timestamp().validated(by: Timestamp())
    }
    
    required init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        createdAt = try (node.extract("createdAt") as String).validated(by: Timestamp())
        updatedAt = try (node.extract("updatedAt") as String).validated(by: Timestamp())
        userId = try node.extract("user_id")
    }
    
    func makeNode(context: Context) throws -> Node {
        
        var baseFields: [String: NodeRepresentable?] = [
            "id": id,
            "createdAt": createdAt.value,
            "updatedAt": updatedAt.value,
            "user_id": userId
        ]
        
        for (key, value) in customFields() {
            baseFields.updateValue(value, forKey: key)
        }
        
        return try Node(node: baseFields)
    }
    
    func customFields() -> [String: NodeRepresentable?] {
        return [:]
    }
    
    static func prepare(_ database: Database) throws {
        try database.create(T.tableName()) { schema in
            schema.id()
            schema.string("createdAt")
            schema.string("updatedAt")
            schema.parent(User.self, optional: false)
            try T.addFieldsToSchema(schema)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(T.tableName())
    }
    
}
