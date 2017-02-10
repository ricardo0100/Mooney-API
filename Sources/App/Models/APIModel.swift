
import Foundation
import Vapor
import Fluent
import HTTP

protocol APIModel: RequestInitializable, Model {
    
    associatedtype APIModel: Model
    
    var userId: Node? { get set }
    
    static func fetchByUser(_ user: User) throws -> [APIModel]
    
    func belongsToUser(_ user: User) -> Bool
    func updateWithRequest(request: Request) throws
    
}

extension APIModel {
    
    static func fetchByUser(_ user: User) throws -> [APIModel] {
        return try APIModel.query().filter("user_id", user.id!).all()
    }
    
    func belongsToUser(_ user: User) -> Bool {
        return userId == user.id
    }
    
    func user() throws -> Parent<User> {
        return try parent(userId)
    }
    
    static func extractStringFromData(_ data: Content, withField field: String) throws -> String {
        guard let value = data[field]?.string else {
            throw Abort.custom(status: .badRequest, message: "\(field) field is missing")
        }
        return value
    }
    
}
