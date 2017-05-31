//
//  Registration.swift
//  MymoUpload
//
//  Created by Towhid on 9/11/14.
//  Copyright (c) 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import UIKit
import CoreDataStack

/*{
    "dateOfBirth": "2017-05-29T21:37:29.561Z",
    "email": "string",
    "gender": "MALE",
    "name": "string",
    "password": "string",
    "phone": "string",
    "reTypePassword": "string"
}*/

open class RegistrationForm: BaseForm {
    var email :NSString?
    var password :NSString?
    var reTypePassword :NSString?
    var name :NSString?
    var dateOfBirth :NSString?
    var gender: NSString?
    var phone: NSString?
}
