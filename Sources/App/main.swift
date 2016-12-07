import Vapor
import VaporMySQL

let drop = Droplet()

try drop.addProvider(VaporMySQL.Provider.self)

drop.preparations.append(User.self)
drop.preparations.append(Account.self)
drop.preparations.append(Category.self)
drop.preparations.append(Transaction.self)

drop.middleware.append(AuthenticationMiddleware())

let api = API()
drop.collection(api)

let website = Website()
drop.collection(website)

drop.run()
