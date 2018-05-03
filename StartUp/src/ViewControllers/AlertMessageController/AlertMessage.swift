//
//  AlertMessage.swift
//  MymoUpload
//
//  Created by Towhid on 9/15/14.
//  Copyright (c) 2014 Towhid (Selise.ch). All rights reserved.
//

import UIKit
import CoreDataStack
import CoreNetworkStack
import WebServiceKit

enum AlertMessageType: Int {
    
    case alert
    case errorBanner
}

@available(iOS 8.0, *)
@objcMembers
class AlertMessage: NGObject {
   
    var type: AlertMessageType = .errorBanner
    var title: NSString = ""
    var message: NSString = ""
    var cancelAction: UIAlertAction?
    var otherActions: [UIAlertAction]?
}
