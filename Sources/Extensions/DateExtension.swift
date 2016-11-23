import Foundation

extension Date {
    
    static let dateFormatter = DateFormatter(withFormat: "yyyy-MM-dd HH:mm:ss")
    
    func timestamp() -> String {
        return Date.dateFormatter.string(from:self)
    }
    
}

extension DateFormatter {
    
    convenience init(withFormat format: String) {
        self.init()
        self.dateFormat = format
    }
    
}
