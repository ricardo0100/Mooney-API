import Foundation
import Vapor
import HTTP

final class CategoriesController: ResourceRepresentable {
    
    typealias Model = Category
    
    public func makeResource() -> Resource<Category> {
        return Resource(
            index: index,
            store: store,
            show: show,
            replace: update,
            destroy: destroy
        )
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        let user = try getUserFromRequest(request: request)
        let category = try Category.query().filter("user_id", user.id!).all()
        let json = try JSON(node: category)
        return json
    }
    
    func store(request: Request) throws -> ResponseRepresentable {
        let user = try getUserFromRequest(request: request)
        
        guard let name = request.data["name"]?.string else {
            throw Abort.custom(status: Status.badRequest, message: "Name not provided")
        }
        
        var category = try Category(name: name, userId: user.id)
        try category.save()
        
        let id: Int = category.id!.int!
        return "Category created with ID: \(id)"
    }
    
    func show(request: Request, item category: Category) throws -> ResponseRepresentable {
        let user = try getUserFromRequest(request: request)
        if (user.id != category.userId) {
            throw Abort.custom(status: Status.badRequest, message: "Authentication error")
        }
        return try JSON(node: category)
    }
    
    func update(request: Request, item category: Category) throws -> ResponseRepresentable {
        let user = try getUserFromRequest(request: request)
        if (user.id != category.userId) {
            throw Abort.custom(status: Status.badRequest, message: "Authentication error")
        }
        
        var updatedCategory = category
        
        guard let name = request.data["name"]?.string else {
            throw Abort.custom(status: Status.badRequest, message: "Name not provided")
        }
        
        updatedCategory.name = try name.validated(by: NotEmpty())
        updatedCategory.updatedAt = try Date().timestamp().validated(by: Timestamp())
        
        try updatedCategory.save()
        
        let id: Int = updatedCategory.id!.int!
        return "Category with ID: \(id) updated"
    }
    
    func destroy(request: Request, item user: Category) throws -> ResponseRepresentable {
        return user
    }
    
}
