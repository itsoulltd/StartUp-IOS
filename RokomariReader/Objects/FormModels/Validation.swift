//
//  Validation.swift
//  RokomariReader
//
//  Created by Towhid Islam on 12/2/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation

protocol FormValidator {
    func addRule(rule: DNRule, forKey key: String) -> Void
    func validate(key: String, forValue value: AnyObject?) -> (invalid:Bool, reasons:[String])
}
