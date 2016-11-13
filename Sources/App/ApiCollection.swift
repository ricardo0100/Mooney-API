import Vapor
import HTTP
import Routing

class ApiCollection: RouteCollection {

    let accountsController = AccountsController()

    typealias Wrapped = HTTP.Responder
    func build<B: RouteBuilder where B.Value == Wrapped>(_ builder: B) {
        let api = builder.grouped("api")
        let accounts = api.grouped("accounts")

        accounts.get { request in
            return self.accountsController.retrieveAllAccounts(request)
        }

        accounts.post { request in
            if let name = request.data["name"]?.string {
                var account = Account(name: name)
                try account.save()
                return "ID: \(account.id)"
            }
            return ":("
        }
    }
}
