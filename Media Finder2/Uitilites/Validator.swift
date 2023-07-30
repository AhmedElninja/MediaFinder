//
//  Validator.swift
//  Media Finder2
//
//  Created by Ahmed Alaa on 20/05/2023.
//

import Foundation

class Validator {
    
    //Mark: - Singletone.
    private static let sharedInstance = Validator()
    
    static func shared() -> Validator {
        return Validator.sharedInstance
    }
    //Mark: - Propreties.
    private let format = "SELF MATCHES %@"
    
    func isValidEmail(email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let pred = NSPredicate(format: format, regex)
        return pred.evaluate(with: email)
    }
    func isValidPassword(password: String) -> Bool {
        let regex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]{8,}$"
        let pred = NSPredicate(format: format, regex)
        return pred.evaluate(with: password)
    }
    func isValidPhone(number: String) -> Bool {
        let regex = "^[0-9]{11}$"
        let pred = NSPredicate(format: format, regex)
        return pred.evaluate(with: number)
    }
}
