//
//  FileItem.swift
//  DubaiArchive
//
//  Created by Towhid on 4/29/15.
//  Copyright (c) 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation
import SeliseToolKit
import MobileCoreServices

@objc protocol IDocumentMetadata{
    var documentUrl: NSURL {get}
    var documentName: String {get}
    func getAttributes() -> NSDictionary?
    func modifiedDate() -> NSDate?
    func creationDate() -> NSDate?
    func documentType() -> NSString?
}

public class DNDocumentMetadata: DNObject, IDocumentMetadata{
    
    var URL: NSURL!
    
    var documentUrl: NSURL{
        return URL
    }
    
    var documentName: String{
        return URL.lastPathComponent!
    }
    
    init(url: NSURL) {
        super.init(info: ["URL":url])
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    deinit{
        print("deinit \(NSStringFromClass(self.dynamicType))")
    }
    
    func getAttributes() -> NSDictionary?{
        var attributes: NSDictionary? = nil
        do{
            attributes = try NSFileManager.defaultManager().attributesOfItemAtPath(URL.path!) as NSDictionary
        } catch let error as NSError{
            print("getAttributes -> \(error.debugDescription)")
        } catch{
            print("Error in \(#function) at line \(#line)")
        }
        return attributes
    }
    
    func modifiedDate() -> NSDate? {
        //
        if let attributes = getAttributes(){
            return attributes.fileModificationDate()
        }
        return nil
    }
    
    func creationDate() -> NSDate? {
        //
        if let attributes = getAttributes(){
            return attributes.fileCreationDate()
        }
        return nil
    }
    
    func documentType() -> NSString? {
        //
        if let attributes = getAttributes(){
            return attributes.fileType()
        }
        return nil
    }
    
    //MARK: DNObject Protocol
    
    public override func updateValue(value: AnyObject!, forKey key: String!) {
        if key == "URL"{
            if value is String{
                URL = NSURL(fileURLWithPath: (value as! String))
            }
            else{
                super.updateValue(value, forKey: key)
            }
        }
        else{
            super.updateValue(value, forKey: key)
        }
    }
    
    public override func serializeValue(value: AnyObject!, forKey key: String!) -> AnyObject! {
        if key == "URL"{
            return URL.path
        }
        else {
            return super.serializeValue(value, forKey: key)
        }
    }
}

@objc protocol IDNFile{
    var metadata: IDocumentMetadata {get}
    var name: String {get}
    var URL: NSURL{get}
    func isFile() -> Bool
    func fileExist() -> Bool
    func mimeType() -> NSString
    var sizeInBytes: Double {get}
    var sizeInKBytes: Double {get}
    var sizeInMBytes: Double {get}
    var sizeInGBytes: Double {get}
    func read() -> NSData?
    func write(data: NSData) -> Bool
    func write(from readfile: IDNFile, bufferSize: Int, progress: IDNFileProgress?) -> Bool
    func writeAsynch(from readfile: IDNFile, bufferSize: Int, progress: IDNFileProgress?, completionHandler: ((Bool) -> Void)?) -> Void
    func writeAsynch(to file: IDNFile, bufferSize: Int, progress: IDNFileProgress?, completionHandler: ((Bool) -> Void)?) -> Void
    func delete() -> Bool
    func rename(to rename: String) -> Bool
}

@objc protocol IDNFileProgress: NSObjectProtocol{
    func readWriteProgress(progress: Double) -> Void
}

@objc protocol DNRemoteFileDelegate{
    func didFinishSynch(request: DNRequest, file: IDNFile) -> Void
}

public class DNRemoteFile: DNObject{

    var request: DNRequest!
    var localFile: DNFile!
    weak var delegate: DNRemoteFileDelegate?
    
    //MARK: Initializer and Private Funcs
    
    init(request: DNRequest, file: IDNFile, delegate: DNRemoteFileDelegate? = nil) {
        super.init(info: ["request":request, "localFile":file])
        self.delegate = delegate
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    deinit{
        print("deinit \(NSStringFromClass(self.dynamicType))")
    }
    
    func synchLocal(progress: ContentProgressDelegate, reSynch: Bool = false){
        //
        if (reSynch || localFile.fileExist() == false){
            RemoteSession.defaultSession().downloadContent(self.request, progressDelegate: progress, onCompletion: { (url: NSURL!, response: NSURLResponse!, error: NSError!) -> Void in
                //
                if url != nil{
                    let data = NSData(contentsOfURL: url!)
                    self.localFile.write(data!)
                    self.delegate?.didFinishSynch(self.request, file: self.localFile)
                }
            })
        }
    }
    
    //MARK: DNObject Protocol
    
    public override func updateValue(value: AnyObject!, forKey key: String!) {
        if key == "request"{
            if value is NSDictionary{
                let info: NSDictionary = (value as! NSDictionary)
                let allKeys = info.allKeys as NSArray
                if allKeys.containsObject("localFileURL"){
                    request = DNFileUploadRequest(info: info as! [NSObject : AnyObject])
                }else{
                    request = DNRequest(info: info as! [NSObject : AnyObject])
                }
            }else{
                super.updateValue(value, forKey: key)
            }
        }
        else{
            super.updateValue(value, forKey: key)
        }
    }
    
    public override func serializeValue(value: AnyObject!, forKey key: String!) -> AnyObject! {
        return super.serializeValue(value, forKey: key)
    }
    
}

public class DNFile: DNObject, IDNFile {
    
    //MARK: Properties
    var URL: NSURL{
        get{
            return _metadata.documentUrl
        }
    }
    
    var name: String{
        return metadata.documentName
    }
    
    var size: NSNumber = 0.0
    
    var sizeInBytes: Double{
        return size.doubleValue
    }
    var sizeInKBytes: Double{
        return sizeInBytes/1024 //in KB
    }
    var sizeInMBytes: Double{
        return sizeInKBytes/1024 //in MB
    }
    var sizeInGBytes: Double{
        return sizeInMBytes/1024 //in GB
    }
    
    var _metadata: IDocumentMetadata!
    
    var metadata: IDocumentMetadata{
        return _metadata
    }
    
    //MARK: Initializer and Private Funcs
    
    init(url: NSURL) {
        super.init()
        _metadata = DNDocumentMetadata(url: url)
        calculateSize()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        calculateSize()
    }
    
    private func calculateSize(){
        //
        if fileExist() == false{
            print("FileSize Cal Error -> File Does not exist")
            return
        }
        var fileSize: AnyObject?
        do {
            try URL.getResourceValue(&fileSize, forKey: NSURLFileSizeKey)
            if let fSize = fileSize as? NSNumber{
                size = NSNumber(double: fSize.doubleValue)
            }
        } catch let error1 as NSError {
            print("FileSize Cal Error -> \(error1.debugDescription)")
        }
        catch{
            print("FileSize Cal Error -> Unknown!?!")
        }
    }
    
    //MARK: Public Function
    
    func fileExist() -> Bool{
        //
        if URL.fileURL == false{
            return false
        }
        let exist = NSFileManager.defaultManager().fileExistsAtPath(URL.path!)
        return exist
    }
    
    func isFile() -> Bool{
        //
        if let type = documentType(){
            return type == NSFileTypeRegular
        }
        return false
    }
    
    func modifiedDate() -> NSDate? {
        //
        if fileExist() == false{
            print("File Error -> File:(\(name)) Does not exist")
            return nil
        }
        return metadata.modifiedDate()
    }
    
    func creationDate() -> NSDate? {
        //
        if fileExist() == false{
            print("File Error -> File:(\(name)) Does not exist")
            return nil
        }
        return metadata.creationDate()
    }
    
    func documentType() -> NSString? {
        //
        if fileExist() == false{
            print("File Error -> File:(\(name)) Does not exist")
            return nil
        }
        return metadata.documentType()
    }
    
    func mimeType() -> NSString{
        //
        if fileExist() == false{
            print("File Error -> File:(\(name)) Does not exist")
            return "--"
        }
        //taking help from StackOverFlow
        let fileName = name as NSString
        let UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileName.pathExtension as CFStringRef, nil)
        let mimeType = UTTypeCopyPreferredTagWithClass(UTI!.takeUnretainedValue(), kUTTagClassMIMEType)
        let mime = mimeType!.takeUnretainedValue() as NSString
        return mime
    }
    
    //MARK: operations
    
    func read() -> NSData?{
        if fileExist() == false{
            print("File Error -> File:(\(name)) Does not exist")
            return nil
        }
        let data = NSData(contentsOfURL: URL)
        return data
    }
    
    func write(data: NSData) -> Bool{
        let isDone = data.writeToURL(URL, atomically: true)
        calculateSize()
        return isDone
    }
    
    final func calculateProgress(totalReadWrite rwBytes: Int, totalDataLength tdlBytes: Double, progress: IDNFileProgress?){
        if let delegate = progress{
            let calc = (Double(100 * rwBytes) / tdlBytes)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                delegate.readWriteProgress(calc)
            })
        }
    }
    
    private func write(from readfile: IDNFile, bufferSize: Int = 1024, progress: IDNFileProgress? = nil, encrypt: ((NSData) -> NSData)) -> Bool{
        var endResult = false
        if (readfile.fileExist() == false){
            print("File Error -> File:(\(readfile.name)) Does not exist")
            endResult = false
        }
        var readError: NSError?
        var writeError: NSError?
        do {
            let readHandler = try NSFileHandle(forReadingFromURL: readfile.URL)
            readHandler.seekToFileOffset(0)
            if (readError != nil){
                print("File Error -> \(readError?.debugDescription)")
                endResult = false
            }
            
            if (fileExist()){
                delete()
            }
            if (NSFileManager.defaultManager().createFileAtPath(URL.path!, contents: nil, attributes: nil)){
                do {
                    let writeHandler = try NSFileHandle(forWritingToURL: self.URL)
                    writeHandler.seekToFileOffset(0)
                    if (writeError != nil){
                        print("File Error -> \(writeError?.debugDescription)")
                        endResult = false
                    }
                    var buffer = readHandler.readDataOfLength(bufferSize)
                    var totalWritenLength: Int = 0
                    let readFileTotalBytes = readfile.sizeInBytes
                    while(buffer.length > 0){
                        totalWritenLength += buffer.length
                        let decoded = encrypt(buffer)
                        writeHandler.writeData(decoded)
                        calculateProgress(totalReadWrite: totalWritenLength, totalDataLength: readFileTotalBytes, progress: progress)
                        buffer = readHandler.readDataOfLength(bufferSize)
                        if buffer.length == 0{
                            encrypt(buffer)
                        }
                    }
                    print("Total bytes to read \(readfile.sizeInBytes) from \(readfile.name)")//
                    print("Total bytes writen \(totalWritenLength) to \(name)")//
                    writeHandler.synchronizeFile()
                    writeHandler.closeFile()
                    endResult = true
                } catch let error as NSError {
                    writeError = error
                } catch{
                    print("Error in \(#function) at line \(#line)")
                }
            }
            readHandler.closeFile()
        } catch let error as NSError {
            readError = error
        } catch{
            print("Error in \(#function) at line \(#line)")
        }
        return endResult
    }
    
    func write(from readfile: IDNFile, bufferSize: Int = 1024, progress: IDNFileProgress? = nil) -> Bool{
        let endResult = self.write(from: readfile, bufferSize: bufferSize, progress: progress) { (unEncrypted) -> NSData in
            return unEncrypted
        }
        return endResult
    }
    
    func writeAsynch(from readfile: IDNFile, bufferSize: Int = 1024, progress: IDNFileProgress? = nil, completionHandler: ((Bool) -> Void)? = nil){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
            let result = self.write(from: readfile, bufferSize: bufferSize, progress: progress)
            if let completion = completionHandler{
                completion(result)
            }
        })
    }
    
    func writeAsynch(to file: IDNFile, bufferSize: Int = 1024, progress: IDNFileProgress? = nil, completionHandler: ((Bool) -> Void)? = nil){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
            let result = file.write(from: self, bufferSize: bufferSize, progress: progress)
            if let completion = completionHandler{
                completion(result)
            }
        })
    }
    
    func delete() -> Bool{
        if fileExist(){
            var error: NSError?
            var result: Bool = false
            do {
                try NSFileManager.defaultManager().removeItemAtURL(URL)
                result = true
            } catch let error1 as NSError {
                error = error1
                result = false
                (error != nil) ? print("file delete -> \(error?.debugDescription)") : print("\(name) deleted")
            } catch{
                print("Error in \(#function) at line \(#line)")
            }
            return result
        }
        return false
    }
    
    func rename(to rename: String) -> Bool {
        if fileExist(){
            if let sourcePath = URL.path{
                let oldName = name
                let dirPath = (sourcePath as NSString).stringByDeletingLastPathComponent
                let destinationPath = (dirPath as NSString).stringByAppendingPathComponent(rename)
                var error: NSError?
                var result: Bool = false
                do {
                    try NSFileManager.defaultManager().moveItemAtPath(sourcePath, toPath: destinationPath)
                    result = true
                } catch let error1 as NSError {
                    error = error1
                    result = false
                    (error != nil) ? print("file delete -> \(error?.debugDescription)") : print("\(oldName) rename to \(name)")
                } catch{
                    print("Error in \(#function) at line \(#line)")
                }
                if result{
                    let fileUrl = NSURL(fileURLWithPath: destinationPath)
                    _metadata = DNDocumentMetadata(url: fileUrl)
                    calculateSize()
                }
                return result
            }
        }
        return false
    }
    
    //MARK: DNObject Protocol
    
    public override func updateValue(value: AnyObject!, forKey key: String!) {
        if key == "_metadata"{
            if value is NSDictionary{
                let path = (value as! NSDictionary).objectForKey("URL") as! String
                let url = NSURL(fileURLWithPath: path)
                _metadata = DNDocumentMetadata(url: url)
            }
            else{
                super.updateValue(value, forKey: key)
            }
        }
        else{
            super.updateValue(value, forKey: key)
        }
    }
    
    public override func serializeValue(value: AnyObject!, forKey key: String!) -> AnyObject! {
        return super.serializeValue(value, forKey: key)
    }
    
    override public func updateDate(dateStr: String!) -> NSDate! {
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.FullStyle
        return formatter.dateFromString(dateStr)
    }
    
    override public func serializeDate(date: NSDate!) -> String! {
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.FullStyle
        return formatter.stringFromDate(date)
    }
    
}

@objc protocol IDNSecureFile: NSObjectProtocol{
    func decrypted(bufferSize size: Int, progress: IDNFileProgress?, decrypt: ((NSData) -> NSData)?, completionHandler: (NSData) -> Void ) -> Void
    func encrypted(bufferSize size: Int, progress: IDNFileProgress?, encrypt: ((NSData) -> NSData)?, completionHandler: (NSData) -> Void ) -> Void
    func secureWrite(from readfile: IDNFile, bufferSize: Int, progress: IDNFileProgress?, encrypt: ((NSData) -> NSData)?, completionHandler: ((Bool) -> Void)? )
    func secureWrite(to file: IDNFile, bufferSize: Int, progress: IDNFileProgress?, encrypt: ((NSData) -> NSData)?, completionHandler: ((Bool) -> Void)? )
}

extension DNFile: IDNSecureFile{
    
    private func read(bufferSize size: Int = 1024, progress: IDNFileProgress?, crypto: ((NSData)->NSData)) -> NSData{
        let endResult: NSMutableData = NSMutableData()
        var readError: NSError?
        do {
            let readHandler = try NSFileHandle(forReadingFromURL: URL)
            readHandler.seekToFileOffset(0)
            if (readError != nil){
                print("File Error -> \(readError?.debugDescription)")
                return endResult
            }
            var buffer = readHandler.readDataOfLength(size)
            var totalWritenLength: Int = 0
            while(buffer.length > 0){
                totalWritenLength += buffer.length
                let decoded = crypto(buffer)
                endResult.appendData(decoded)
                calculateProgress(totalReadWrite: totalWritenLength, totalDataLength: sizeInBytes, progress: progress)
                buffer = readHandler.readDataOfLength(size)
                if buffer.length == 0{
                    crypto(buffer)
                }
            }
            print("Total bytes to read \(sizeInBytes) from \(name)")//
            readHandler.closeFile()
        } catch let error as NSError {
            readError = error
        } catch{
            print("Error in \(#function) at line \(#line)")
        }
        return endResult
    }
    
    func decrypted(bufferSize size: Int = 1024, progress: IDNFileProgress?, decrypt: ((NSData) -> NSData)?, completionHandler: (NSData) -> Void) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
            var data: NSData!
            if let crypto = decrypt{
                data = self.read(bufferSize: size, progress: progress, crypto: crypto)
            }
            else{
                data = self.read(bufferSize: size, progress: progress, crypto: { (unEncrypted) -> NSData in
                    return unEncrypted
                })
            }
            completionHandler(data)
        })
    }
    
    func encrypted(bufferSize size: Int = 1024, progress: IDNFileProgress? = nil, encrypt: ((NSData) -> NSData)?, completionHandler: (NSData) -> Void) {
        decrypted(bufferSize: size, progress: progress, decrypt: encrypt, completionHandler: completionHandler)
    }
    
    func secureWrite(to file: IDNFile, bufferSize: Int, progress: IDNFileProgress?, encrypt: ((NSData) -> NSData)?, completionHandler: ((Bool) -> Void)? = nil) {
        (file as! IDNSecureFile).secureWrite(from: self, bufferSize: bufferSize, progress: progress, encrypt: encrypt, completionHandler: completionHandler)
    }
    
    func secureWrite(from readfile: IDNFile, bufferSize: Int = 1024, progress: IDNFileProgress? = nil, encrypt: ((NSData) -> NSData)?, completionHandler: ((Bool) -> Void)? = nil) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
            var result = false
            if let crypto = encrypt{
                result = self.write(from: readfile, bufferSize: bufferSize, progress: progress, encrypt: crypto)
            }
            else{
                result = self.write(from: readfile, bufferSize: bufferSize, progress: progress, encrypt: { (unEncrypetd) -> NSData in
                    return unEncrypetd
                })
            }
            if let completion = completionHandler{
                completion(result)
            }
        })
    }
    
}

