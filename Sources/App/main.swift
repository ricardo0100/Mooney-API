import Vapor
import VaporMySQL

let drop = Droplet()

try drop.addProvider(VaporMySQL.Provider.self)

drop.preparations.append(User.self)
drop.preparations.append(Account.self)
drop.preparations.append(Category.self)
drop.preparations.append(Transaction.self)

let website = Website()
drop.collection(website)

let auth = AuthenticationMiddleware()

let api = API()
drop.grouped(auth).collection(api)

drop.run()
