//
//  FileWriteQueue.swift
//  StartupProjectSampleA
//
//  Created by Towhid Islam on 5/2/15.
//  Copyright (c) 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation
import SeliseToolKit

@objc protocol FileCommend{
    func execute() -> Void
}

public class BaseFileWriteCommend: NSObject {
    
    var receiver: DNFolder!
    var completionCallBack: ((file: DNFile?) -> Void)?
    
    deinit{
        print("deinit \(NSStringFromClass(self.dynamicType))")
    }
}

public class FileWriteCommend: BaseFileWriteCommend, FileCommend {
    
    var fileUrl: NSURL!
    
    init(receiver: DNFolder, fileUrl: NSURL, completion: ((file: DNFile?) -> Void)? = nil) {
        super.init()
        self.receiver = receiver
        self.fileUrl = fileUrl
        self.completionCallBack = completion
    }
    
    func execute() {
        //
        let saved: (isSaved: Bool, url: NSURL?) = receiver.paste(content: DNFile(url: fileUrl), replace: false)
        if saved.isSaved{
            if let block = completionCallBack{
                block(file: DNFile(url: saved.url!))
            }
           print("\(NSStringFromClass(self.dynamicType)) -> Import Successful")
        }
    }
}

public class FileDataWriteCommend: BaseFileWriteCommend, FileCommend {
    
    var fileData: NSData!
    var fileName: String!
    
    init(receiver: DNFolder, fileData: NSData, fileName: String, completion: ((file: DNFile?) -> Void)? = nil) {
        super.init()
        self.receiver = receiver
        self.fileData = fileData
        self.fileName = fileName
        self.completionCallBack = completion
    }
    
    func execute() {
        //
        let name = receiver.resolveChildName(name: fileName)
        let saved: (isSaved: Bool, url: NSURL?) = receiver.saveAs(name, data: fileData)
        if saved.isSaved{
            if let block = completionCallBack{
                block(file: DNFile(url: saved.url!))
            }
            print("\(NSStringFromClass(self.dynamicType)) -> Import Successful")
        }
    }
}

public class FileWriteQueue: NSObject {
    
    private var identifier: String!
    private var queue: Queue = Queue()
    private var lock = NSLock()
    private var running = false
    
    init(identifier: String) {
        //
        super.init()
        self.identifier = identifier
    }
    
    deinit{
        //
        print("deinit \(NSStringFromClass(self.dynamicType))")
    }
    
    final func errorLogger(funcName: String, error: NSError? = nil){
        if let err = error{
            print("\(NSStringFromClass(self.dynamicType)) -> (\(funcName)) :: \(err.debugDescription)")
        }
        else{
            messageLogger(funcName, message: "NSError is nil")
        }
    }
    
    final func messageLogger(funcName: String, message: String){
        print("\(NSStringFromClass(self.dynamicType)) -> (\(funcName)) :: \(message)")
    }
    
    //MARK: Commend Queue
    
    func executeCommend(commend: FileCommend) {
        enqueueCommend(commend)
        kickStart(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0))
    }
    
    final func enqueueCommend(commend: FileCommend){
        lock.lock()
        queue.enqueue(commend)
        lock.unlock()
    }
    
    private func dequeueCommend() -> FileCommend{
        lock.lock()
        let commend = queue.dequeue() as! FileCommend
        lock.unlock()
        return commend
    }
    
    final func kickStart(dispatchQueue: dispatch_queue_t){
        //
        if running == false{
            lock.lock()
            running = true
            lock.unlock()
            dispatch_async(dispatchQueue, { () -> Void in
                self.run()
            })
        }
    }
    
    private final func run(){
        //
        print("Run Start.....\(String.fromCString(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL)))")
        
        while(queue.isEmpty() == false){
            let commend = dequeueCommend()
            commend.execute()
            //NSThread.sleepForTimeInterval(0.50) //FIXME: Delete this line
        }
        if (queue.isEmpty()){
            lock.lock()
            running = false
            lock.unlock()
            print("Run End.....\(String.fromCString(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL)))")
        }
        //
    }
}