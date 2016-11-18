import Vapor
import VaporMySQL

let drop = Droplet()


//MARK: Database
try drop.addProvider(VaporMySQL.Provider.self)
drop.preparations.append(Account.self)
drop.preparations.append(Category.self)
drop.preparations.append(Transaction.self)


//MARK: API
let api = API()
drop.collection(api)


drop.run()
