//import Foundation
//import Vapor
//import HTTP
//
//final class TransactionsController: ResourceRepresentable {
//    
//    typealias Model = Transaction
//    
//    public func makeResource() -> Resource<Transaction> {
//        return Resource(
//            index: index,
//            store: store,
//            show: show,
//            replace: update,
//            destroy: destroy
//        )
//    }
//    
//    func index(request: Request) throws -> ResponseRepresentable {
//        let user = try getUserFromRequest(request: request)
//        let category = try Transaction.query().filter("user_id", user.id!).all()
//        let json = try JSON(node: category)
//        return json
//    }
//    
//    func store(request: Request) throws -> ResponseRepresentable {
//        let user = try getUserFromRequest(request: request)
//        
//        guard let name = request.data["name"]?.string else {
//            throw Abort.custom(status: Status.badRequest, message: "Name not provided")
//        }
//        
//        guard let categoryId = request.data["category_id"]?.int else {
//            throw Abort.custom(status: Status.badRequest, message: "Category ID not provided")
//        }
//        
//        guard let category = try Category.query().filter("id", categoryId).first() else {
//            throw Abort.custom(status: Status.badRequest, message: "Category not found")
//        }
//        
//        if (category.userId != user.id) {
//            throw Abort.custom(status: Status.badRequest, message: "Category not found")
//        }
//        
//        guard let accountId = request.data["account_id"]?.int else {
//            throw Abort.custom(status: Status.badRequest, message: "Account ID not provided")
//        }
//        
//        guard let account = try Account.query().filter("id", accountId).first() else {
//            throw Abort.custom(status: Status.badRequest, message: "Account not found")
//        }
//        
//        if (account.userId != user.id) {
//            throw Abort.custom(status: Status.badRequest, message: "Account not found")
//        }
//        
//        var transaction = try Transaction(name: name, userId: user.id, categoryId: category.id, accountId: account.id)
//        try transaction.save()
//        
//        let id: Int = transaction.id!.int!
//        return "Transaction created with ID: \(id)"
//    }
//    
//    func show(request: Request, item transaction: Transaction) throws -> ResponseRepresentable {
//        let user = try getUserFromRequest(request: request)
//        if (user.id != transaction.userId) {
//            throw Abort.custom(status: Status.badRequest, message: "Authentication error")
//        }
//        return try JSON(node: transaction)
//    }
//    
//    func update(request: Request, item transaction: Transaction) throws -> ResponseRepresentable {
//        let user = try getUserFromRequest(request: request)
//        if (user.id != transaction.userId) {
//            throw Abort.custom(status: Status.badRequest, message: "Authentication error")
//        }
//        
//        var updatedCategory = transaction
//        
//        guard let name = request.data["name"]?.string else {
//            throw Abort.custom(status: Status.badRequest, message: "Name not provided")
//        }
//        
//        updatedCategory.name = try name.validated(by: NotEmpty())
//        updatedCategory.updatedAt = try Date().timestamp().validated(by: Timestamp())
//        
//        try updatedCategory.save()
//        
//        let id: Int = updatedCategory.id!.int!
//        return "Category with ID: \(id) updated"
//    }
//    
//    func destroy(request: Request, item user: Transaction) throws -> ResponseRepresentable {
//        return user
//    }
//    
//}
