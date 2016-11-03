//
//  GenericSynchronizer.swift
//  FlipMobNewGen
//
//  Created by Towhid on 2/4/15.
//  Copyright (c) 2016 Rokomari (https://www.rokomari.com/policy) All rights reserved.
//

import UIKit
import SeliseToolKit

@objc
protocol GenericSynchDelegate{
    func synchronizationSucceed(forRequest: DNRequest?, incomming: NSData) -> Void
    func synchronizationFailed(forRequest: DNRequest?, error: NSError?) -> Void
    optional func downloadSucceed(forRequest: DNRequest?, saveUrl: NSURL) -> Void
    optional func progressListener(forRequest: DNRequest?) -> ProgressListener
}

@objc
protocol ProgressListener{
    func progressUpdate(value: CGFloat) -> Void;
    optional func progressStart() -> Void;
    optional func progressEnd() -> Void;
}

@objc(ContentProgressDelegateImpl)
public class ContentProgressDelegateImpl: DNObject, ContentProgressDelegate {
    
    weak var listener: ProgressListener?
    
    public func progressHandler(handler: ContentProgressHandler!, didFailedWithError error: NSError!) {
        listener?.progressEnd!()
    }
    
    public func progressHandler(handler: ContentProgressHandler!, uploadPercentage percentage: Float) {
        if percentage <= 2.0{
            listener?.progressStart!()
        }
        
        let pro: CGFloat = CGFloat(percentage/100)
        listener?.progressUpdate(pro)
        
        if (handler.totalByteRW >= handler.totalBytesExpectedToRW){
            listener?.progressEnd!()
        }
    }
    
    public func progressHandler(handler: ContentProgressHandler!, downloadPercentage percentage: Float) {
        progressHandler(handler, uploadPercentage: percentage)
    }
    
    deinit{
        print("deinit :: \(self.description)")
    }
}

class SynchConfiguration: DNObject {
    //Hello I do not Have Properties 😜, but have keys
    struct Keys {
        static let MaxTryCount = "maxTryCount"
        static let EnergyStateEnabled = "energyState"
    }
    
    var identifier: NSString!
    
    init(identifier: NSString, info: NSDictionary){
        super.init(info: info as [NSObject : AnyObject])
        self.identifier = identifier
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}

@objc(Tracker)
public class Tracker: DNObject {
    
    var guid: NSString!
    var orderIndex: NSNumber!
    var request: DNRequest?
    var delegate: ContentProgressDelegateImpl?
    var maxTryCount: NSNumber = 1
    var tryCount: NSNumber = 0
    
    deinit{
        print("deinit :: \(self.description)")
    }
    
    override public func updateValue(value: AnyObject!, forKey key: String!) {
        if key == "request"{
            if value is NSDictionary{
                let info: NSDictionary = (value as! NSDictionary)
                let allKeys = info.allKeys as NSArray
                if allKeys.containsObject("localFileURL"){
                    request = DNFileUploadRequest(info: info as [NSObject : AnyObject])
                }else{
                    request = DNRequest(info: info as [NSObject : AnyObject])
                }
            }else{
                super.updateValue(value, forKey: key)
            }
        }
        else if key == "delegate"{
            if value is NSDictionary{
                delegate = nil
            }else{
                super.updateValue(value, forKey: key)
            }
        }else{
            super.updateValue(value, forKey: key)
        }
    }
    
    public override func serializeValue(value: AnyObject!, forKey key: String!) -> AnyObject! {
        return super.serializeValue(value, forKey: key)
    }
    
    ///Ascending order
    class func sort(list: [Tracker]) -> [Tracker]{
        let sorted = list.sort { (objA, objB) -> Bool in
            return objA.orderIndex.integerValue < objB.orderIndex.integerValue
        }
        return sorted
    }
}

@objc
protocol RequestQueue{
    func enqueueRequest(capsul: DNRequest) -> Void
    func enqueueRequest(capsul: DNRequest, progressListener: ProgressListener?)
    func cancelable(capsul: DNRequest) -> Bool
    func cancelRequest(capsul: DNRequest) -> Void
}

@objc(GenericSynchronizer)
public class GenericSynchronizer: NSObject, RequestQueue {
    
    /***************************************THIS IS A GRAY AREA********************************************/
    
    func addCompletionHandler(identifier: String, completionHandler: () -> Void){
        self.session.addCompletionHandler(completionHandler, forSession: identifier)
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    
    init(configuration: SynchConfiguration){
        super.init()
        self.configuration = configuration
        if let isEnabled = configuration.valueForKey(SynchConfiguration.Keys.EnergyStateEnabled)?.boolValue{
            if isEnabled{
                self.session = EnergyStateSession.defaultSession()
            }
        }
        if session == nil{
            self.session = RemoteSession.defaultSession()
        }
    }
    
    deinit{
        print("deinit :: \(self.description)")
    }
    
    func activateInternetReachability(){
        //register for NetworkActivityController's notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GenericSynchronizer.internetReachability(_:)), name: InternetReachableNotification, object: nil)
    }
    
    func deactivateInternetReachability(){
        //unregister from Notification Center
        NSNotificationCenter.defaultCenter().removeObserver(self, name: InternetReachableNotification, object: nil)
    }
    
    func internetReachability(notification: NSNotification){
        //
        if let userInfo = notification.userInfo as NSDictionary?{
            if let isReachable = userInfo.objectForKey(kInternetReachableKey) as? NSNumber{
                if isReachable.boolValue{
                    //now reachable
                    print("Internet Now available For GenericSynchronization")
                    kickStart()
                }
                else{
                    //not reachable
                    print("Internet Disconnect For GenericSynchronization")
                }
            }
        }
    }
    
    private var session: RemoteSession!
    private var requestQueue = Queue()
    private var runningQueue = Queue()
    private var cancelableContainer = NSMutableDictionary(capacity: 7)
    private let lock = NSLock()
    weak var delegate: GenericSynchDelegate?
    private var configuration: SynchConfiguration!
    
    var networkReachable: Bool{
        return NetworkActivityController.sharedInstance().isInternetReachable()
    }
    
    private func enqueueTracker(capsul: DNRequest) -> Tracker?{
        let tracker = Tracker()
        tracker.request = capsul
        if let maxCount = configuration.valueForKey(SynchConfiguration.Keys.MaxTryCount) as? NSNumber{
            tracker.maxTryCount = maxCount
        }
        requestQueue.enqueue(tracker)
        return tracker
    }
    
    private func enqueueTracker(capsul: DNRequest, progressListener: ProgressListener?) -> Tracker? {
        if let tracker = self.enqueueTracker(capsul){
            if let _ = progressListener{
                tracker.delegate = ContentProgressDelegateImpl()
                tracker.delegate?.listener = progressListener
            }
            return tracker
        }
        return nil
    }
    
    func enqueueRequest(capsul: DNRequest) {
        enqueueTracker(capsul)
        kickStart()
    }
    
    func enqueueRequest(capsul: DNRequest, progressListener: ProgressListener?) {
        enqueueTracker(capsul, progressListener: progressListener)
        kickStart()
    }
    
    func cancelable(capsul: DNRequest) -> Bool {
        if cancelableContainer.count <= 0{
            return false
        }
        if let _ = cancelableContainer.objectForKey(capsul.hash){
            return true
        }
        else{
            return false
        }
    }
    
    func cancelRequest(capsul: DNRequest) {
        //println("request hash \(capsul.hash)")
        if let taskObj = cancelableContainer.objectForKey(capsul.hash){
            if taskObj is RemoteTask{
                let task = taskObj as! RemoteTask
                task.cancelTask()
                removeTask(capsul)
            }
        }else{
            let hashValue = capsul.hash
            cancelableContainer.setObject(capsul, forKey: hashValue)
        }
    }
    
    final func preCancelCheck(request: DNRequest?) -> Bool{
        var isCancelable = false
        guard let capsul = request else{
            return isCancelable
        }
        if let taskObj = cancelableContainer.objectForKey(capsul.hash){
            isCancelable = (taskObj is RemoteTask) ? false : true
        }
        if isCancelable{
            removeTask(capsul)
        }
        return isCancelable
    }
    
    final func kickStart(){
        //when running queue is empty, means nothing is running
        lock.lock()
        if runningQueue.isEmpty() == true{
            execute()
        }
        lock.unlock()
    }
    
    private func addTask(task: RemoteTask, forTracker: Tracker){
        if let request = forTracker.request{
            let hashValue = request.hash
            forTracker.maxTryCount = 1
            forTracker.tryCount = 1
            cancelableContainer.setObject(task, forKey: hashValue)
        }
    }
    
    private func removeTask(forRequest: DNRequest?){
        if let request = forRequest{
            cancelableContainer.removeObjectForKey(request.hash)
        }
    }
    
    private func execute(){
        if !networkReachable{
            return
        }
        if let tracker = requestQueue.dequeue() as? Tracker{
            if preCancelCheck(tracker.request){
                execute()
            }
            else{
                runningQueue.enqueue(tracker)
                NetworkActivityController.sharedInstance().startNetworkActivity()
                let task = session.sendUtilityMessage(tracker.request, onCompletion: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
                    NetworkActivityController.sharedInstance().stopNetworkActivity()
                    self.removeTask(tracker.request)
                    self.onCompletion(data, response: response, error: error)
                })
                addTask(task, forTracker: tracker)
            }
        }
    }
    
    private func onCompletion(data: AnyObject!, response: NSURLResponse!, error: NSError!){
        if (error != nil){
            self.whenFailed(error)
        }
        else{
            if let httpResponse = response as? NSHTTPURLResponse{
                if (httpResponse.statusCode == HttpStatusCode.OK.rawValue
                    || httpResponse.statusCode == HttpStatusCode.Created.rawValue){
                        self.whenSucceed(data)
                }else{
                    self.whenFailed(error)
                }
            }
            else{
                self.whenSucceed(data)
            }
        }
        //Chaining the execution
        self.execute()
    }
    
    private func whenFailed(error: NSError!){
        print("\(NSStringFromClass(self.dynamicType)) -> is running on \(String.fromCString(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL)))")
        if (error != nil) {
            print(error.debugDescription)
        }
        if let tracker = self.runningQueue.dequeue() as? Tracker{
            tracker.tryCount = NSNumber(integer: tracker.tryCount.integerValue + 1)
            if tracker.tryCount.integerValue <= tracker.maxTryCount.integerValue{
                self.requestQueue.enqueue(tracker)
            }
            else{
                self.delegate?.synchronizationFailed(tracker.request, error: error)
            }
        }
    }
    
    private func whenSucceed(data: AnyObject!){
        print(data)
        print("\(NSStringFromClass(self.dynamicType)) -> is running on \(String.fromCString(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL)))")
        if let tracker = self.runningQueue.dequeue() as? Tracker{
            if data is NSData{
                self.delegate?.synchronizationSucceed(tracker.request, incomming: data as! NSData)
            }
            else if data is NSURL{
                if let downloadSucceed = self.delegate?.downloadSucceed{
                    downloadSucceed(tracker.request, saveUrl: data as! NSURL)
                }
            }
        }
    }
    
}

/// 👉 Don't use use PersistableSynchronizer(or any subclass) from background thread.
/// this class is not thread safe. Calling from other then Main Thread might causes crash.
@objc(PersistableSynchronizer)
public class PersistableSynchronizer: GenericSynchronizer {
    
    private var identifier: String!
    private var orderIndex: Int = -1
    private var manager: PropertyList!
    
    override init(configuration: SynchConfiguration){
        super.init(configuration: configuration)
        self.identifier = configuration.identifier as String
        //
        manager = PropertyList(fileName: "\(identifier)_synchronizer_queue", directoryType: NSSearchPathDirectory.DocumentDirectory, dictionary: true)
        if let order = manager.itemForKey(identifier) as? NSNumber{
            orderIndex = order.integerValue
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PersistableSynchronizer.applicationDidEnterBackground(_:)), name: UIApplicationDidEnterBackgroundNotification, object: nil)
    }
    
    convenience init(configuration: SynchConfiguration, remoteSession: RemoteSession){
        self.init(configuration: configuration)
        self.session = remoteSession
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidEnterBackgroundNotification, object: nil)
    }
    
    func applicationDidEnterBackground(notification: NSNotification){
        print("\(NSStringFromClass(self.dynamicType)) -> applicationDidEnterBackground Called")
        saveState()
    }
    
    private override func enqueueTracker(capsul: DNRequest) -> Tracker?{
        let tracker = Tracker()
        tracker.guid = NSUUID().UUIDString
        tracker.request = capsul
        if let maxCount = configuration.valueForKey(SynchConfiguration.Keys.MaxTryCount) as? NSNumber{
            tracker.maxTryCount = maxCount
        }
        requestQueue.enqueue(tracker)
        saveState(tracker)
        return tracker
    }
    
    private func saveState(tracker: Tracker){
        orderIndex += 1
        let newIndex = orderIndex
        tracker.orderIndex = newIndex
        manager.addItemToCollection(NSNumber(integer: newIndex), forKey: identifier)
        let archivedTracker = NSKeyedArchiver.archivedDataWithRootObject(tracker)
        manager.addItemToCollection(archivedTracker, forKey: tracker.guid)
    }
    
    private func removeState(tracker: Tracker){
        manager.removeItemFromCollectionForKey(tracker.guid)
    }
    
    private func temporaryQueue() -> Queue{
        let collection = manager.readOnlyCollection() as! NSDictionary
        let queue = Queue()
        let allKeys = collection.allKeys as! [String]
        var trackers = [Tracker]()
        for key in allKeys{
            if key == identifier{
                continue
            }
            let data = collection.objectForKey(key) as! NSData
            let tracker = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! Tracker
            trackers.append(tracker)
        }
        let commends = Tracker.sort(trackers)
        for commend in commends{
            queue.enqueue(commend)
        }
        return queue
    }
    
    private func restoreQueue(from tempQueue: Queue){
        if (tempQueue.isEmpty() == true){
            return
        }
        //very complex senarios
        if requestQueue.isEmpty() {
            requestQueue = tempQueue
        }
        else{
            while(tempQueue.isEmpty() == false){
                requestQueue.enqueue(tempQueue.dequeue())
            }
        }
        //complex end
    }
    
    func restoreState(){
        //New Implementation.
        let _queue = temporaryQueue()
        restoreQueue(from: _queue)
        //thats it.
    }
    
    func saveState(){
        //New Implementation.
        if manager != nil{
            if (manager.save() == true){
                print("\(NSStringFromClass(self.dynamicType)) -> Manager last order index = \(orderIndex)")
            }
        }
    }
    
    private func reconstructProgressHandlerFor(tracker: Tracker){
        if tracker.delegate == nil{
            tracker.delegate = ContentProgressDelegateImpl()
            if let progressListener = self.delegate?.progressListener{
                tracker.delegate?.listener = progressListener(tracker.request)
            }
        }
    }
    
    private override func execute(){
        if !networkReachable{
            return
        }
        if let tracker = requestQueue.dequeue() as? Tracker{
            if preCancelCheck(tracker.request){
                execute()
            }
            else{
                runningQueue.enqueue(tracker)
                NetworkActivityController.sharedInstance().startNetworkActivity()
                let task = session.sendUtilityMessage(tracker.request, onCompletion: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
                    NetworkActivityController.sharedInstance().stopNetworkActivity()
                    self.removeTask(tracker.request)
                    self.onCompletion(data, response: response, error: error)
                })
                addTask(task, forTracker: tracker)
            }
        }
    }
    
    private override func whenFailed(error: NSError!){
        print("\(NSStringFromClass(self.dynamicType)) -> is running on \(String.fromCString(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL)))")
        if (error != nil) {
            print(error.debugDescription)
        }
        if let tracker = self.runningQueue.dequeue() as? Tracker{
            tracker.tryCount = NSNumber(integer: tracker.tryCount.integerValue + 1)
            if tracker.tryCount.integerValue <= tracker.maxTryCount.integerValue{
                self.requestQueue.enqueue(tracker)
                self.saveState()
            }
            else{
                self.removeState(tracker)
                self.saveState()
                self.delegate?.synchronizationFailed(tracker.request, error: error)
            }
        }
    }
    
    private override func whenSucceed(data: AnyObject!){
        print("\(NSStringFromClass(self.dynamicType)) -> is running on \(String.fromCString(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL)))")
        if let tracker = self.runningQueue.dequeue() as? Tracker{
            self.removeState(tracker)
            self.saveState()
            if data is NSData{
                self.delegate?.synchronizationSucceed(tracker.request, incomming: data as! NSData)
            }
            else if data is NSURL{
                if let downloadSucceed = self.delegate?.downloadSucceed{
                    downloadSucceed(tracker.request, saveUrl: data as! NSURL)
                }
            }
        }
    }
    
}

/// 👉 Don't use use PersistableSynchronizer(or any subclass) from background thread.
/// this class is not thread safe. Calling from other then Main Thread might causes crash.
@objc(DownloadSynchronizer)
public class DownloadSynchronizer: PersistableSynchronizer {
    
    private override func execute() {
        if !networkReachable{
            return
        }
        if let tracker = requestQueue.dequeue() as? Tracker{
            if preCancelCheck(tracker.request){
                execute()
            }
            else{
                runningQueue.enqueue(tracker)
                reconstructProgressHandlerFor(tracker)
                NetworkActivityController.sharedInstance().startNetworkActivity()
                let task = session.downloadContent(tracker.request, progressDelegate: tracker.delegate, onCompletion: { (url: NSURL!, response: NSURLResponse!, error: NSError!) -> Void in
                    NetworkActivityController.sharedInstance().stopNetworkActivity()
                    self.removeTask(tracker.request)
                    self.onCompletion(url, response: response, error: error)
                })
                addTask(task, forTracker: tracker)
            }
        }
    }
    
}

/// 👉 Don't use PersistableSynchronizer(or any subclass) from background thread.
/// this class is not thread safe. Calling from other then Main Thread might causes crash.
@objc(UploadSynchronizer)
public class UploadSynchronizer: PersistableSynchronizer {
    
    private override func execute() {
        if !networkReachable{
            return
        }
        if let tracker = requestQueue.dequeue() as? Tracker{
            if preCancelCheck(tracker.request){
                execute()
            }
            else{
                runningQueue.enqueue(tracker)
                if tracker.request is DNFileUploadRequest{
                    reconstructProgressHandlerFor(tracker)
                    NetworkActivityController.sharedInstance().startNetworkActivity()
                    let task = session.uploadContent(tracker.request as! DNFileUploadRequest, progressDelegate: tracker.delegate, onCompletion: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
                        //
                        NetworkActivityController.sharedInstance().stopNetworkActivity()
                        self.removeTask(tracker.request)
                        self.onCompletion(data, response: response, error: error)
                    })
                    addTask(task, forTracker: tracker)
                }
                else{
                    super.execute()
                }
            }
        }
    }
    
}

/// 👉 Don't use PersistableSynchronizer(or any subclass) from background thread.
/// this class is not thread safe. Calling from other then Main Thread might causes crash.
@objc(UploadOnceSynchronizer)
public class UploadOnceSynchronizer: UploadSynchronizer {
    
    private var backgroundModeActivated = false
    private var lastTracker: Tracker? {
        get{
            guard let unarchived = NSUserDefaults.standardUserDefaults().objectForKey("CurrentTrackerKey") as? NSData else{
                return nil
            }
            let tracker = NSKeyedUnarchiver.unarchiveObjectWithData(unarchived) as? Tracker
            return tracker
        }
        set{
            self.lastTracker = newValue
            if let nValue = newValue{
                let archived = NSKeyedArchiver.archivedDataWithRootObject(nValue)
                NSUserDefaults.standardUserDefaults().setObject(archived, forKey: "CurrentTrackerKey")
                //NSUserDefaults.standardUserDefaults().synchronize()
            }
        }
    }
    
    func applicationDidEnterBackground(){
        backgroundModeActivated = true
    }
    
    func applicationWillEnterForeground(){
        backgroundModeActivated = false
    }
    
    override func addCompletionHandler(identifier: String, completionHandler: () -> Void) {
        super.addCompletionHandler(identifier, completionHandler: completionHandler)
        applicationDidEnterBackground()
    }
    
    private func ignore(tracker tracker: Tracker) -> Bool{
        if let lTracker = lastTracker{
            if tracker.guid == lTracker.guid{
                return true
            }
        }
        lastTracker = tracker
        return false
    }
    
    private override func execute() {
        if !networkReachable{
            return
        }
        if let tracker = requestQueue.dequeue() as? Tracker{
            if preCancelCheck(tracker.request){
                execute()
            }
            else{
                //Test
                if ignore(tracker: tracker){
                    execute()
                    return
                }
                //
                runningQueue.enqueue(tracker)
                if tracker.request is DNFileUploadRequest{
                    reconstructProgressHandlerFor(tracker)
                    NetworkActivityController.sharedInstance().startNetworkActivity()
                    let task = session.uploadContent(tracker.request as! DNFileUploadRequest, progressDelegate: tracker.delegate, onCompletion: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
                        NetworkActivityController.sharedInstance().stopNetworkActivity()
                        self.removeTask(tracker.request)
                        self.onCompletion(data, response: response, error: error)
                    })
                    addTask(task, forTracker: tracker)
                }
                else{
                    super.execute()
                }
            }
        }
    }
    
}

