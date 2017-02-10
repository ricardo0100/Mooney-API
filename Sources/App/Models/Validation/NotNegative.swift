
import Foundation
import Vapor

class NotNegative: ValidationSuite {
    
    public static func validate(input value: Double) throws {
        if value < 0.0 {
            throw Abort.custom(status: .badRequest, message: "Value should not be negative")
        }
    }

}
