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
        fetchAllBooks()
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
        browser.fetch(query) { (res) in
            for book in res{
                print(book.serializeIntoInfo())
            }
        }
    }
    
    func searchBooks(){
        let searchQ = SearchQuery()
        searchQ.query = "Purfume"
        searchQ.sort = ["edition", "isbn"]
        browser.search(searchQ) { (res) in
            for book in res{
                print(book.serializeIntoInfo())
            }
        }
    }
}

