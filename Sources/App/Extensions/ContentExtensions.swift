
import Foundation
import Vapor

extension Content {
    
    func extractString(_ identifier: String) throws -> String {
        guard let value = self[identifier]?.string else {
            throw Abort.custom(status: .badRequest, message: "\(identifier) field is missing")
        }
        return value
    }
    
    func extractDouble(_ identifier: String) throws -> Double {
        guard let value = self[identifier]?.double else {
            throw Abort.custom(status: .badRequest, message: "\(identifier) field is missing")
        }
        return value
    }
    
    func extractInt(_ identifier: String) throws -> Int {
        guard let value = self[identifier]?.int else {
            throw Abort.custom(status: .badRequest, message: "\(identifier) field is missing")
        }
        return value
    }
    
}
