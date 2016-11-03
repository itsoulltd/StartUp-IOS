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
public class AppStateMatchine: NSObject{
    
    private struct Shared {
        static let Matchine = AppStateMatchine()
    }
    
    public class func SharedMatchine() -> AppStateMatchine{
        return Shared.Matchine
    }
    
    private var stateMatchine: GKStateMachine!
    private var states: [GKState]!
    private var currentStateIndex: Int = -1
    
    override init() {
        super.init()
        loadDefaults()
    }
    
    func loadDefaults(){
        states = [AppState()]
        stateMatchine = GKStateMachine(states: states)
    }
    
    func loadStates(states: [GKState]){
        self.states.appendContentsOf(states)
        stateMatchine = GKStateMachine(states: self.states)
    }
    
    func move(to stateType: GKState.Type){
        stateMatchine.enterState(stateType)
    }
    
    func moveNext(){
        currentStateIndex += 1
        if currentStateIndex < states.count{
            let state = states[currentStateIndex]
            stateMatchine.enterState(state.dynamicType)
            if currentStateIndex == states.count{
                currentStateIndex = -1
            }
        }
    }
    
    func moveBack(){
        currentStateIndex -= 1
        if currentStateIndex > -1{
            let state = states[currentStateIndex]
            stateMatchine.enterState(state.dynamicType)
        }
    }
    
}
