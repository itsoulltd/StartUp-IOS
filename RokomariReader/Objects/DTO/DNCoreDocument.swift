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
        if let bundleStr = Bundle.main.infoDictionary!["CFBundleName"] as? String{
            result = bundleStr
        }
        return result
    }()
   
    fileprivate struct ConstantVariables{
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
        print("deinit \(NSStringFromClass(type(of: self)))")
    }
    
    fileprivate var document: UIManagedDocument?
    
    fileprivate func initCoreData(){
        //
        let localURL = saveURL(moduleName)
        document = UIManagedDocument(fileURL: localURL)
        let documentOptions = NSMutableDictionary(capacity: 5)
        documentOptions.setObject(NSNumber(value: true as Bool), forKey: NSMigratePersistentStoresAutomaticallyOption as NSCopying)
        documentOptions.setObject(NSNumber(value: true as Bool), forKey: NSInferMappingModelAutomaticallyOption as NSCopying)
        document?.persistentStoreOptions = documentOptions as [AnyHashable: Any]
        //Check at the local sandbox
        if FileManager.default.fileExists(atPath: savePath(moduleName)){
            print("Already Created So try to Open")
            document?.open(completionHandler: { (success: Bool) -> Void in
                print("File Is Open")
            })
        }
        else{
            // 1. save it out, 2. close it, 3. read it back in.
            // You probably can get away with doing less
            document?.save(to: localURL, for: UIDocumentSaveOperation.forCreating, completionHandler: { [weak self] (success: Bool) -> Void in
                //
                if success{
                    print("1. save it out")
                    self?.document?.close(completionHandler: { [weak self] (success: Bool) -> Void in
                        print("2. close it")
                        self?.document?.open(completionHandler: { (success: Bool) -> Void in
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
    
    fileprivate func saveURL(_ fileName: String) -> URL{
        let directories = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask) as NSArray
        let finalUrl = (directories.lastObject as! URL).appendingPathComponent(fileName)
        return finalUrl
    }
    
    fileprivate func savePath(_ fileName: String) -> String{
        let finalPath = saveURL(fileName).path
        return finalPath
    }
    
}
