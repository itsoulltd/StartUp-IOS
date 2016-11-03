//
//  DNCoreDocument.swift
//  StartupProjectSampleA
//
//  Created by Towhid on 4/12/15.
//  Copyright (c) 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import UIKit
import CoreData

class DNCoreDocument: NSObject {
    
    var moduleName: String = {
        var result: String = "humpti_dumpti"
        if let bundleStr = NSBundle.mainBundle().infoDictionary!["CFBundleName"] as? String{
            result = bundleStr
        }
        return result
    }()
   
    private struct ConstantVariables{
        static let sharedInstance = DNCoreDocument()
    }
    
    class var sharedInstance: DNCoreDocument {
        get{
            return ConstantVariables.sharedInstance
        }
    }
    
    override init() {
        super.init()
        initCoreData()
    }
    
    deinit{
        print("deinit \(NSStringFromClass(self.dynamicType))")
    }
    
    private var document: UIManagedDocument?
    
    private func initCoreData(){
        //
        let localURL = saveURL(moduleName)
        document = UIManagedDocument(fileURL: localURL)
        let documentOptions = NSMutableDictionary(capacity: 5)
        documentOptions.setObject(NSNumber(bool: true), forKey: NSMigratePersistentStoresAutomaticallyOption)
        documentOptions.setObject(NSNumber(bool: true), forKey: NSInferMappingModelAutomaticallyOption)
        document?.persistentStoreOptions = documentOptions as [NSObject : AnyObject]
        //Check at the local sandbox
        if NSFileManager.defaultManager().fileExistsAtPath(savePath(moduleName)){
            print("Already Created So try to Open")
            document?.openWithCompletionHandler({ (success: Bool) -> Void in
                print("File Is Open")
            })
        }
        else{
            // 1. save it out, 2. close it, 3. read it back in.
            // You probably can get away with doing less
            document?.saveToURL(localURL, forSaveOperation: UIDocumentSaveOperation.ForCreating, completionHandler: { [weak self] (success: Bool) -> Void in
                //
                if success{
                    print("1. save it out")
                    self?.document?.closeWithCompletionHandler({ [weak self] (success: Bool) -> Void in
                        print("2. close it")
                        self?.document?.openWithCompletionHandler({ (success: Bool) -> Void in
                            print("3. read it back in")
                        })
                    })
                }
                else{
                    print("\(self?.moduleName) could not be saved.")
                }
            })
        }
    }
    
    func managedContext() -> NSManagedObjectContext?{
        if let doc = document{
            return doc.managedObjectContext
        }
        return nil
    }
    
    private func saveURL(fileName: String) -> NSURL{
        let directories = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask) as NSArray
        let finalUrl = (directories.lastObject as! NSURL).URLByAppendingPathComponent(fileName)
        return finalUrl
    }
    
    private func savePath(fileName: String) -> String{
        let finalPath = saveURL(fileName).path
        return finalPath!
    }
    
}
