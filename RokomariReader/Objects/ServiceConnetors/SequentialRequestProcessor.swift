//
//  SequentialRequestProcessor.swift
//  StartupProjectSampleA
//
//  Created by Towhid on 12/31/15.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation
import UIKit
import CoreDataStack

public protocol RequestProcessingProtocol: NSObjectProtocol{
    var parserType: Response.Type {get set}
    var request: DNRequest {get set}
    var linkedProcess: RequestProcessingProtocol? {get set}
    var workingMemory: [NSObject : AnyObject] {get}
    var workingMemoryHandler: ((previous: [NSObject : AnyObject]) -> [NSObject : AnyObject]) {get set}
    func addObjectToMemory(value: AnyObject, key: String) -> Void
    func copyObject(fromMemory memory: [NSObject : AnyObject], key: String) -> Void
    func copyAll(from: [NSObject : AnyObject]) -> Void
    func execute(success: ((next: RequestProcessingProtocol?, previousResponse: [NGObjectProtocol]?) -> Void), failed: ((abort: Bool, reason: Response) -> Void)) -> Void
}

public protocol RequestProcessorDelegate: NSObjectProtocol{
    func processingDidFinished(processor: RequestProcessor, finalResponse: [NGObjectProtocol]?) -> Void
    func processingDidFailed(processor: RequestProcessor, failedResponse: NGObjectProtocol) -> Void
    func processingWillStart(processor: RequestProcessor, forProcess process: RequestProcessingProtocol) -> Void
    func processingDidEnd(processor: RequestProcessor, forProcess process: RequestProcessingProtocol) -> Void
}

public class RequestProcessor: NSObject{
    
    private var stack: [RequestProcessingProtocol] = [RequestProcessingProtocol]()
    private var abortMark: Bool = false
    private weak var delegate: RequestProcessorDelegate?
    private var errorResponseType: NGObject.Type!
    
    public required init(delegate: RequestProcessorDelegate?, errorResponse: NGObject.Type = NGObject.self){
        super.init()
        self.delegate = delegate
        self.errorResponseType = errorResponse
    }
    
    func push(process process: RequestProcessingProtocol){
        if let last = stack.last{
            process.linkedProcess = last
        }
        stack.append(process)
    }
    
    func start(){
        if let last = stack.last{
            self.delegate?.processingWillStart(self, forProcess: last)
            last.execute({ (next, previousResponse) -> Void in
                if (self.abortMark){
                    let errorResponse = self.errorResponseType.init()
                    errorResponse.updateWithInfo(["errorMessage":"Unknown"])
                    self.delegate?.processingDidFailed(self, failedResponse: errorResponse)
                    return
                }
                else if (next == nil){
                    self.delegate?.processingDidFinished(self, finalResponse: previousResponse)
                    return
                }
                else{
                    let doneProcess = self.stack.removeLast()
                    self.delegate?.processingDidEnd(self, forProcess: doneProcess)
                    self.start()
                }
                }, failed: { (abort, reason) -> Void in
                    print(reason.serializeIntoInfo())
                    if abort{
                        self.delegate?.processingDidFailed(self, failedResponse: reason)
                        return
                    }
                    if self.abortMark == false{
                        self.stack.removeLast()
                        self.start()
                    }
            })
        }
    }
    
    func abort() {
        abortMark = true
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
}


public class TransactionProcess: NSObject, RequestProcessingProtocol{
    
    public required init(request: DNRequest, parserType: Response.Type, memoryHandler: ((previous: [NSObject : AnyObject]) -> [NSObject : AnyObject])? = nil) {
        super.init()
        self.request = request
        self.parserType = parserType
        if let handler = memoryHandler{
            self.workingMemoryHandler = handler
        }
    }
    
    var _workingMemoryHandler: ((previous: [NSObject : AnyObject]) -> [NSObject : AnyObject]) = { (previous: [NSObject : AnyObject]) -> [NSObject : AnyObject] in
        var to: [NSObject : AnyObject] = [NSObject : AnyObject]()
        for (key, value) in previous{
            to[key as! String] = value
        }
        return to
    }
    public var workingMemoryHandler: ((previous: [NSObject : AnyObject]) -> [NSObject : AnyObject]) {
        get{
            return _workingMemoryHandler
        }
        set{
            _workingMemoryHandler = newValue
        }
    }
    
    private var _parserType: Response.Type = Response.self
    public var parserType: Response.Type {
        get{
            return _parserType
        }
        set{
            _parserType = newValue
        }
    }
    
    private var _workingMemory: [NSObject : AnyObject] = [NSObject : AnyObject]()
    public var workingMemory: [NSObject : AnyObject]{
        get{
            return _workingMemory
        }
    }
    
    public func addObjectToMemory(value: AnyObject, key: String) {
        _workingMemory[key] = value
    }
    
    public func copyObject(fromMemory memory: [NSObject : AnyObject], key: String) {
        _workingMemory[key] = memory[key]
    }
    
    public func copyAll(from: [NSObject : AnyObject]){
        for (key, value) in from{
            _workingMemory[key as! String] = value
        }
    }
    
    private weak var _linkedProcess: RequestProcessingProtocol?
    public var linkedProcess: RequestProcessingProtocol? {
        get{
            return _linkedProcess
        }
        set{
            _linkedProcess = newValue
        }
    }
    
    private var _request: DNRequest!
    public var request: DNRequest {
        get{
            return _request
        }
        set{
            _request = newValue
        }
    }
    
    public func execute(success: ((next: RequestProcessingProtocol?, previousResponse: [NGObjectProtocol]?) -> Void), failed: ((abort: Bool, reason: Response) -> Void)) -> Void {
        NetworkActivityController.sharedInstance().startNetworkActivity()
        RemoteSession.defaultSession().sendMessage(request) { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            if let res = response as? NSHTTPURLResponse
                where (res.statusCode == HttpStatusCode.OK.rawValue || res.statusCode == HttpStatusCode.Created.rawValue){
                do{
                    if let info = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary{
                        print(info)
                        let parseInfo = self.parserType.init(info: info as! [NSObject : AnyObject])
                        parseInfo.handleHttpResponse(res, error: error)
                        self.linkedProcess?.copyAll(self.workingMemoryHandler(previous: self.workingMemory))
                        success(next: self.linkedProcess, previousResponse: [parseInfo])
                    }
                    else if let info = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSArray{
                        print(info)
                        var responseItems = [NGObject]()
                        for item in info as! [[NSObject : AnyObject]]{
                            let parseInfo = self.parserType.init(info: item)
                            parseInfo.handleHttpResponse(res, error: error)
                            responseItems.append(parseInfo)
                        }
                        self.linkedProcess?.copyAll(self.workingMemoryHandler(previous: self.workingMemory))
                        success(next: self.linkedProcess, previousResponse: responseItems)
                    }
                    else{
                        self.linkedProcess?.copyAll(self.workingMemoryHandler(previous: self.workingMemory))
                        success(next: self.linkedProcess, previousResponse: nil)
                    }
                }catch let error as NSError{
                    print("\(error.debugDescription)")
                    let reason = Response()
                    reason.handleHttpResponse(response as? NSHTTPURLResponse, error: error)
                    failed(abort: true, reason: reason)
                }
            }
            else{
                let reason = Response()
                reason.handleHttpResponse(response as? NSHTTPURLResponse, error: error)
                failed(abort: true, reason: reason)
            }
            NetworkActivityController.sharedInstance().stopNetworkActivity()
        }
    }
    
}
