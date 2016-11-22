import Vapor
import HTTP

final class AccountsController: ResourceRepresentable {
    
    typealias Model = Account
    
    public func makeResource() -> Resource<Account> {
        return Resource(
            index: index,
            store: store
        )
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        let accounts = try Account.query().all()
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

}
