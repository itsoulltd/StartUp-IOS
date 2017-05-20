//
//  AppStateMatchine.swift
//  Jamahook
//
//  Created by Towhid on 11/30/15.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation
import GameplayKit

@available(iOS 9.0, *)
open class AppStateMatchine: NSObject{
    
    fileprivate struct Shared {
        static let Matchine = AppStateMatchine()
    }
    
    open class func SharedMatchine() -> AppStateMatchine{
        return Shared.Matchine
    }
    
    fileprivate var stateMatchine: GKStateMachine!
    fileprivate var states: [GKState]!
    fileprivate var currentStateIndex: Int = -1
    
    override init() {
        super.init()
        loadDefaults()
    }
    
    func loadDefaults(){
        states = [AppState()]
        stateMatchine = GKStateMachine(states: states)
    }
    
    func loadStates(_ states: [GKState]){
        self.states.append(contentsOf: states)
        stateMatchine = GKStateMachine(states: self.states)
    }
    
    func move(to stateType: GKState.Type){
        stateMatchine.enter(stateType)
    }
    
    func moveNext(){
        currentStateIndex += 1
        if currentStateIndex < states.count{
            let state = states[currentStateIndex]
            stateMatchine.enter(type(of: state))
            if currentStateIndex == states.count{
                currentStateIndex = -1
            }
        }
    }
    
    func moveBack(){
        currentStateIndex -= 1
        if currentStateIndex > -1{
            let state = states[currentStateIndex]
            stateMatchine.enter(type(of: state))
        }
    }
    
}
