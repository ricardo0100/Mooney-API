
import Foundation
import Vapor

class TransactionType: ValidationSuite {
    
    public static func validate(input value: String) throws {
        if (![TransactionTypes.Credit.rawValue, TransactionTypes.Debit.rawValue].contains(value)) {
            throw Abort.custom(status: .badRequest, message: "Invalid transaction type")
        }
    }
    
}
