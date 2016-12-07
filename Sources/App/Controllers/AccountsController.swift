import Foundation
import Vapor
import HTTP

final class AccountsController: ResourceRepresentable {
    
    typealias Model = Account
    
    public func makeResource() -> Resource<Account> {
        return Resource(
            index: index,
            store: store,
            show: show,
            replace: update,
            destroy: destroy
        )
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        let accounts = try Account.query().all()
        let userID = request.headers["userID"]
        let json = try JSON(node: accounts)
        return json
    }
    
    func store(request: Request) throws -> ResponseRepresentable {
        guard let name = request.data["name"]?.string else {
            throw Abort.custom(status: Status.badRequest, message: "Name not provided")
        }
        
        var account = try Account(name: name)
        try account.save()
        
        let id: Int = account.id!.int!
        return "Account created with ID: \(id)"
    }
    
    func show(request: Request, item account: Account) throws -> ResponseRepresentable {
        return try JSON(node: account)
    }
    
    func update(request: Request, item account: Account) throws -> ResponseRepresentable {
        var updatedAccount = account
        
        guard let name = request.data["name"]?.string else {
            throw Abort.custom(status: Status.badRequest, message: "Name not provided")
        }
        
        updatedAccount.name = try name.validated(by: NotEmpty())
        updatedAccount.updatedAt = try Date().timestamp().validated(by: Timestamp())
        
        try updatedAccount.save()
        
        let id: Int = updatedAccount.id!.int!
        return "Account with ID: \(id) updated"
    }
    
    func destroy(request: Request, item user: Account) throws -> ResponseRepresentable {
        return user
    }

}
