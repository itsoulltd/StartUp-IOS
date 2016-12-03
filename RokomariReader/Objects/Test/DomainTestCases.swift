//
//  DomainTestCases.swift
//  HoxroCaseTracker
//
//  Created by Towhid Islam on 9/7/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import UIKit
import SeliseToolKit

class DomainTestCases: NSObject {

    var userManagement: UserManagement = UserManagement(profileType: UserProfile.self)
    var monitor: TRVSMonitor = TRVSMonitor(expectedSignalCount: 1)
    var user = User()
    var browser: EBookBrowser = EBookBrowser()
    
    func runTest(){
        print("Test Is Running")
        login()
        //fetchAllBooks()
        searchBooks()
        //fetchAllPublisher()
        //fetchAllAuthors()
        //fetchAllCategory()
    }
    
    func login(){
        let model = Login()
        model.password = "admin"
        model.username = "admin"
        user.login(model) { (response) in
            print(response?.id_token!)
            self.monitor.signal()
        }
        monitor.wait()
    }
    
    func fetchAllBooks(){
        let query = Query()
        query.sort = ["edition", "isbn"]
        browser.fetch(query) { (books) in
            for book in books{
                print(book.serializeIntoInfo())
            }
            self.monitor.signal()
        }
        monitor.wait()
    }
    
    func searchBooks(){
        let searchQ = SearchQuery()
        searchQ.applyFieldValidation()
        searchQ.query = "Purfume hi there"
        //searchQ.sort = ["edition", "isbn"]
        
        let tuple = searchQ.validate("query", forValue: nil)
        if tuple.invalid == false {
            browser.search(searchQ) { (books) in
                for book in books{
                    print(book.serializeIntoInfo())
                }
                self.monitor.signal()
            }
            monitor.wait()
        }else{
            print("\(tuple.reasons.first!)")
        }
    }
    
    func fetchAllPublisher(){
        let query = Query()
        browser.publishers(query) { (publishers) in
            for publisher in publishers{
                print(publisher.serializeIntoInfo())
            }
            self.monitor.signal()
        }
        monitor.wait()
    }
    
    func fetchAllCategory(){
        let query = Query()
        browser.categories(query) { (categories) in
            for category in categories{
                print(category.serializeIntoInfo())
            }
            self.monitor.signal()
        }
        monitor.wait()
    }
    
    func fetchAllAuthors(){
        let query = Query()
        browser.authors(query) { (authors) in
            for author in authors{
                print(author.serializeIntoInfo())
            }
            self.monitor.signal()
        }
        monitor.wait()
    }
}

