
import Foundation
import Vapor
import Fluent
import HTTP

protocol APIModel: RequestInitializable, Model {
    
    associatedtype APIModel: Model
    
    var userId: Node { get set }
    
    func updateWithRequest(request: Request) throws

}

extension APIModel {
    
    static func fetchBy(user: User) throws -> [APIModel] {
        return try APIModel.query().filter("user_id", user.id!).all()
    }
    
    func belongsToUser(_ user: User) -> Bool {
        return userId == user.id
    }
    
    func user() throws -> Parent<User> {
        return try parent(userId)
    }
    
    static func fetchBy(id: Int) throws -> APIModel {
        guard let item = try APIModel.query().filter("id", id).first() else {
            throw Abort.custom(status: .badRequest, message: "\(APIModel.self) with id \(id) not found")
        }
        
        return item
    }
    
}
