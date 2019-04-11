//
//  ValidationHelper.swift
//  Answerer
//
//  Created by negar on 98/Farvardin/22 AP.
//  Copyright © 1398 negar. All rights reserved.
//

import Foundation

class ValidationHelper {

    class func validateName(name:String) -> Bool {
        let nameRegEx = "[A-Za-z ]"

        let name = NSPredicate(format: "SELF MATCHES %@", nameRegEx)
        return name.evaluate(with: name)
    }

    class func validateCellPhone(phone: String) -> Bool {
        let PHONE_REGEX = "[0][0-9]{10}"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        if phoneTest.evaluate(with: phone) {
            return true
        }
        return false
    }

    class func validateEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }

}
