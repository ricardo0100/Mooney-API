import Foundation
import Vapor

class Timestamp: ValidationSuite {
    
    //Regex for: YYYY-MM-DD HH:MM:SS
    static let regex = try! NSRegularExpression(pattern: "\\d\\d\\d\\d-\\d\\d-\\d\\d \\d\\d:\\d\\d:\\d\\d", options: .caseInsensitive)
    
    public static func validate(input value: String) throws {
        let x = self.regex.rangeOfFirstMatch(in: value, range: NSRange(location: 0, length: value.count))
        //TODO: Validate if is valid date
        let valid = x.location != NSNotFound
        if !valid {
            throw Abort.custom(status: .badRequest, message: "Invalid Timestamp")
        }
    }
    
}
