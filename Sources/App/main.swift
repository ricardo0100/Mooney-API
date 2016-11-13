import Vapor
import VaporMySQL

let drop = Droplet()

//Database Set Up
try drop.addProvider(VaporMySQL.Provider.self)
drop.preparations.append(Account.self)

//API
let api = ApiCollection()
drop.collection(api)

drop.run()
