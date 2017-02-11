
import Foundation
import Vapor

class UserOwns<T: APIModel>: Validator {
    
    var user: User
    
    init(user: User) {
        self.user = user
    }
    
    func validate(input value: Int) throws {
        
        let error = Abort.custom(status: .notFound, message: "\(T.self) with ID: \(value) not found")
        
        guard let resource = try T.fetchBy(id: value) as? T else {
            throw error
        }
        if !resource.belongsToUser(user) {
            throw error
        }
    }
    
}
