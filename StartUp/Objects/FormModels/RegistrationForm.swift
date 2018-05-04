//
//  Registration.swift
//  MymoUpload
//
//  Created by Towhid on 9/11/14.
//  Copyright © 2018 ITSoulLab (https://www.itsoullab.com). All rights reserved.
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

@objcMembers
open class RegistrationForm: BaseForm {
    var email :NSString?
    var password :NSString?
    var reTypePassword :NSString?
    var name :NSString?
    var dateOfBirth :NSString?
    var gender: NSString?
    var phone: NSString?
}
