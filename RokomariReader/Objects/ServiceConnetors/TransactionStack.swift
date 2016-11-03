//
//  TransactionStack.swift
//  RokomariReader
//
//  Created by Towhid Islam on 10/31/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import UIKit
import SeliseToolKit

class TransactionStack: NSObject, RequestProcessorDelegate {
    
    private var processor: RequestProcessor!
    private var callBack: ((received: [DNObjectProtocol]?) -> Void)?
    
    required init(callBack: ((received: [DNObjectProtocol]?) -> Void)?) {
        super.init()
        self.callBack = callBack
        self.processor = RequestProcessor(delegate: self, errorResponse: Response.self)
    }
    
    func push(process: RequestProcessingProtocol){
        self.processor.push(process: process)
    }
    
    func commit(){
        self.processor.start()
    }
    
    func processingDidFinished(processor: RequestProcessor, finalResponse: [DNObjectProtocol]?) {
        guard let callBack = self.callBack else{
            return
        }
        callBack(received: finalResponse)
    }
    
    func processingDidFailed(processor: RequestProcessor, failedResponse: DNObjectProtocol) {
        guard let callBack = self.callBack else{
            return
        }
        callBack(received: [failedResponse])
    }
    
    func processingWillStart(processor: RequestProcessor, forProcess process: RequestProcessingProtocol) {
        //TODO
    }
    
    func processingDidEnd(processor: RequestProcessor, forProcess process: RequestProcessingProtocol) {
        //TODO
    }
}
