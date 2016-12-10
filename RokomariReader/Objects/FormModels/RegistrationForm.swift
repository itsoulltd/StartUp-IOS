//
//  Registration.swift
//  MymoUpload
//
//  Created by Towhid on 9/11/14.
//  Copyright (c) 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import UIKit
import SeliseToolKit

/*{
    "activated": true,
    "authorities": [
    "string"
    ],
    "createdBy": "string",
    "createdDate": "2016-10-29T17:08:28.548Z",
    "email": "string",
    "firstName": "string",
    "id": 0,
    "langKey": "string",
    "lastModifiedBy": "string",
    "lastModifiedDate": "2016-10-29T17:08:28.548Z",
    "lastName": "string",
    "login": "string",
    "password": "string"
}*/

public class RegistrationForm: BaseForm {
    var email :NSString?
    var password :NSString?
    var passwordConfirmation :NSString?
    var firstName :NSString?
    var lastName :NSString?
}
