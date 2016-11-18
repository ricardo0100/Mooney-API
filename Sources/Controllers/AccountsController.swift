import Foundation
import JSON
import HTTP

final class AccountsController {

    func retrieveAllAccounts(_ req: Request) -> ResponseRepresentable {
      let accounts = try! Account.query().all()
      let json = try! JSON(node: accounts)
      return json
    }

}
