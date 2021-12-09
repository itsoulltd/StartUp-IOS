//
//  DomainTestCases.swift
//  StartUp
//
//  Created by Towhid Islam on 9/7/16.
//  Copyright © 2018 ITSoulLab (https://www.itsoullab.com). All rights reserved.
//

import UIKit
import CoreDataStack
import CoreNetworkStack
import WebServiceKit
import NGAppKit

class DomainTestCases: NSObject {

    var userManagement: UserManagement = AppRouter.shared().getAccount()
    var monitor: TRVSMonitor = TRVSMonitor(expectedSignalCount: 1)
    var user = User()

    var items: [NGObjectProtocol] = {
        var items = [NGObjectProtocol]()
        items.append(NGObject(info: ["name":"towhid","age":32,"dob":DateManager .sharedInstance().day(after: 54) ?? Date()]))
        items.append(NGObject(info: ["name":"Sohana","age":23,"dob":DateManager .sharedInstance().day(after: 23) ?? Date()]))
        items.append(NGObject(info: ["name":"Tanvir","age":28,"dob":DateManager .sharedInstance().day(after: 12) ?? Date()]))
        items.append(NGObject(info: ["name":"Sumaiya","age":19,"dob":DateManager .sharedInstance().day(after: 19) ?? Date()]))
        items.append(NGObject(info: ["name":"Maruf","age":32,"dob":DateManager .sharedInstance().day(after: 20) ?? Date()]))
        items.append(NGObject(info: ["name":"Tushin","age":14,"dob":DateManager .sharedInstance().day(after: 20) ?? Date()]))
        return items
    }()
    
    func runTest(){
        print("Test Is Running")
        login()
        //fetchAllBooks()
        //searchBooks()
        //fetchAllPublisher()
        //fetchAllAuthors()
        //fetchAllCategory()
        //rokomaryHelp()
        //sortTest(by:"name", commend: AlphabeticalSort())
        //sortTest(by:"age", commend: NumericSort())
        //sortTest(by:"dob", commend: DateSort())
        //groupBy()
    }
    
    func groupBy() -> Void {
        let dic = NGObject.groupBy("age", onCollection: items as! [NGObject])
        for (key, value) in dic as! [AnyHashable:NSArray] {
            print("\(key) : \n")
            for val in value as! [NGObject] {
                print(val.serializeIntoInfo()!)
            }
        }
    }
    
    func sortTest(by keyPath: String, commend: SortCommand){
        print("-------------------------------------------------")
        for item in items {
            print(item.serializeIntoInfo()!)
        }
        print("After Sort:")
        let sortedItems = commend.sort(items, forKeyPath: keyPath, order: ComparisonResult.orderedAscending)
        for item in sortedItems {
            print(item.serializeIntoInfo()!)
        }
        print("-------------------------------------------------")
    }
    
    func login(){
        let model = LoginForm()
        model.password = "admin"
        model.username = "admin"
        user.login(model) { (response) in
            print(response?.id_token! as Any)
            self.monitor.signal()
        }
        monitor.wait()
        
        user.isSignedIn { (yes) in
            print("\(yes)")
        }
    }
    
    func rokomaryHelp(){
        let contactus = ContactUsForm(info: ["email" as NSObject: "m.towhid.islam@gmail.com" as AnyObject,
            "message" as NSObject: "Need Some Assistance" as AnyObject,
            "name" as NSObject: "Towhid" as AnyObject,
            "phone" as NSObject: "01712645571",
            "status": "responded",
            "subject": "Hi there!"])
        
        self.user.contactUs(contactus!) { (res) in
            if let r = res{
                print(r.serializeIntoInfo()!)
            }
        }
        
    }
}

