import Vapor
import VaporMySQL
import Auth
import Cookies
import Foundation

let drop = Droplet()

try drop.addProvider(VaporMySQL.Provider.self)

drop.preparations.append(User.self)
drop.preparations.append(Account.self)
drop.preparations.append(Category.self)
drop.preparations.append(Transaction.self)

let website = Website()
drop.collection(website)

let auth = AuthMiddleware(user: User.self)
drop.middleware.append(auth)

let api = API()
drop.collection(api)

drop.run()
