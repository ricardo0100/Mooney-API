import Vapor

class NotEmpty: ValidationSuite {
    
    public static func validate(input value: String) throws {
        let trimmedString = value.trim()
        if trimmedString.count == 0 {
            throw error(with: value)
        }
    }
    
}
