
import Foundation
import Vapor
import HTTP

class APIResource<T: APIModel>: ResourceRepresentable {
    
    func makeResource() -> Resource<T> {
        return Resource(
            index: index,
            store: store,
            show: show,
            replace: update
        )
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        let user = try request.user()
        let items = try T.fetchByUser(user)
        let json = try JSON(node: items)
        return json
    }
    
    func store(request: Request) throws -> ResponseRepresentable {
        var item = try T(request: request)
        try item.save()
        guard let id = item.id?.int else {
            throw Abort.serverError
        }
        return try JSON(node: ["status" : "\(T.self) created successfully", "id": id])
    }
    
    func show(request: Request, item: T) throws -> ResponseRepresentable {
        let user = try request.user()
        if (!item.belongsToUser(user)) {
            throw Abort.custom(status: Status.notFound, message: "\(T.self) not found")
        }
        return try JSON(node: item)
    }
    
    func update(request: Request, item: T) throws -> ResponseRepresentable {
        var item = item
        try item.updateWithRequest(request: request)
        try item.save()
        return try JSON(node: ["status" : "\(T.self) updated successfully"])
    }
    
}
