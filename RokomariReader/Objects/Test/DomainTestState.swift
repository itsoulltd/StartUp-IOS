//
//  DomainTestState.swift
//  HoxroCaseTracker
//
//  Created by Towhid Islam on 9/7/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation
import GameplayKit
import CoreDataStack

@available(iOS 9.0, *)
class DomainTestState: AppState {
    
    var testRun: DomainTestCases = DomainTestCases()
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return true
    }
    
    override func didEnter(from previousState: GKState?) {
        testRun.runTest()
    }
}
