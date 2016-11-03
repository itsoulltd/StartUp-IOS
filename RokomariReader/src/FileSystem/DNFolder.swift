//
//  BaseWizard.swift
//  DubaiArchive
//
//  Created by Towhid on 4/29/15.
//  Copyright (c) 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation

@objc protocol IDNFolder{
    var metadata: IDocumentMetadata {get}
    var name: String {get}
    var URL: NSURL {get}
    func path() -> NSString?
    func isFolder() -> Bool
    func exist() -> Bool
    func addSubfolder(name: String) -> IDNFolder
    func subfolder(byName name: String) -> IDNFolder
    func rename(newName name: String) -> Bool
    func delete() -> Bool
    func move(toFolder folder: IDNFolder) -> IDNFolder?
    func copy(fromFolder folder: IDNFolder) -> Bool
    func subfolders(searchBy folderName: String?) -> [IDNFolder]
    func files(searchBy extention: String?) -> [IDNFile]
}

public class DNFolder: NSObject, NSFileManagerDelegate, IDNFolder {
    
    struct ConstantKeys{
        //
    }
    
    private var defaultName = "untitled folder"
    private var _metadata: IDocumentMetadata!
    let fileManager = NSFileManager.defaultManager()
    private lazy var privateFileManager = NSFileManager()
    private var searchDirectoryType: NSSearchPathDirectory!
    
    init(name: String? = nil, searchDirectoryType: NSSearchPathDirectory = NSSearchPathDirectory.DocumentDirectory) {
        super.init()
        self.searchDirectoryType = searchDirectoryType
        if let root = name{
            if root.characters.count >= 1{
                defaultName = root
            }
        }
        createIfNotExist()
    }
    
    private func createIfNotExist(){
        //
        let currentPath = path()
        if fileManager.fileExistsAtPath(currentPath! as String) == false{
            do{
                try fileManager.createDirectoryAtPath(currentPath as! String, withIntermediateDirectories: true, attributes: nil)
                messageLogger("createRootDirectoryIfNotExist", message: "\(defaultName) is created")
            } catch let error as NSError{
                errorLogger("createRootDirectoryIfNotExist", error: error)
            }
        }
        else{
            messageLogger("createRootDirectoryIfNotExist", message: "\(defaultName) already exist")
        }
        _metadata = DNDocumentMetadata(url: NSURL(fileURLWithPath: currentPath! as String))
    }
    
    private func getUserDirectoryPath() -> NSString?{
        //
        let directories = fileManager.URLsForDirectory(searchDirectoryType, inDomains: NSSearchPathDomainMask.UserDomainMask) as NSArray
        let directoryPath = (directories.lastObject as! NSURL).path
        return directoryPath
    }
    
    //MARK: IDNFolder Impl
    
    var metadata: IDocumentMetadata { return _metadata}
    
    func path() -> NSString?{
        //
        let directoryPath = getUserDirectoryPath()
        let finalPath = directoryPath?.stringByAppendingPathComponent(defaultName)
        return finalPath
    }
    
    deinit{
        //remove notifications
        print("deinit \(NSStringFromClass(self.dynamicType))")
    }
    
    func isFolder() -> Bool{
        //
        if let type = self.metadata.documentType(){
            return type == NSFileTypeDirectory
        }
        return false
    }
    
    var name: String{
        return defaultName
    }
    
    var URL: NSURL{
        return self.metadata.documentUrl
    }
    
    private var isFolderExist = false
    
    func exist() -> Bool{
        //
        if isFolderExist == false{
            isFolderExist = fileManager.fileExistsAtPath(URL.path!)
        }
        return isFolderExist
    }
    
    func addSubfolder(name: String) -> IDNFolder{
        //
        if !exist(){
            createIfNotExist()
        }
        let resolvedName = resolveChildName(name: name)
        let newFolder = subfolder(byName: resolvedName)
        return newFolder
    }
    
    func rename(newName name: String) -> Bool{
        //
        if !exist(){
            return false
        }
        if let srcPath = path(){
            if let destPath = getUserDirectoryPath()?.stringByAppendingPathComponent(name){
                if (fileManager.fileExistsAtPath(destPath) == false){
                    do{
                       try fileManager.moveItemAtPath(srcPath as String, toPath: destPath)
                        self.defaultName = name
                        messageLogger("rename", message: "Rename to \(name) is successfull.")
                        return true
                    } catch let error as NSError{
                        errorLogger("rename", error: error)
                    }
                }
            }
        }
        return false
    }
    
    func delete() -> Bool{
        //
        if !exist(){
            return false
        }
        if let path = path(){
            do{
               try fileManager.removeItemAtPath(path as String)
                messageLogger("delete", message: "Delete \(self.name) is successfull.")
                self.isFolderExist = false
                return true
            } catch let error as NSError{
                errorLogger("delete", error: error)
            }
        }
        return false
    }
    
    public func fileManager(fileManager: NSFileManager, shouldProceedAfterError error: NSError, movingItemAtPath srcPath: String, toPath dstPath: String) -> Bool {
        //
        messageLogger("fileManager -> shouldProceedAfterError", message: "Error -> moving Item from path :: \(srcPath)")
        return true
    }
    
    func move(toFolder folder: IDNFolder) -> IDNFolder?{
        //
        if !exist(){
            return nil
        }
        let lastPathComponent = (self.name as NSString).lastPathComponent
        let subFolder = folder.subfolder(byName: lastPathComponent)
        if subFolder.copy(fromFolder: self){
            return subFolder
        }
        return nil
    }
    
    public func fileManager(fileManager: NSFileManager, shouldProceedAfterError error: NSError, copyingItemAtPath srcPath: String, toPath dstPath: String) -> Bool {
        //
        messageLogger("fileManager -> shouldProceedAfterError", message: "Error -> copying Item from path :: \(srcPath)")
        return true
    }
    
    func copy(fromFolder folder: IDNFolder) -> Bool{
        //
        if !exist(){
            return false
        }
        if let srcPath = folder.path(){
            if let destPath = self.path(){
                do{
                    self.privateFileManager.delegate = self
                    try privateFileManager.copyItemAtPath(srcPath as String, toPath: destPath as String)
                    self.privateFileManager.delegate = nil
                    messageLogger("copy", message: "Copy From \(folder.name) is successfull.")
                    return true
                } catch let error as NSError{
                    errorLogger("copy", error: error)
                    self.privateFileManager.delegate = nil
                }
            }
        }
        return false
        //
    }
    
    func subfolder(byName name: String) -> IDNFolder{
        //
        let relativeToParent = "\(self.name)/\(name)"
        let newFolder = DNFolder(name: relativeToParent, searchDirectoryType: searchDirectoryType)
        return newFolder
    }
    
    func subfolders(searchBy folderName: String? = nil) -> [IDNFolder]{
        //
        var folders = [IDNFolder]()
        //var keys: [String] = [NSURLAddedToDirectoryDateKey,NSURLCreationDateKey,NSURLContentAccessDateKey,NSURLContentModificationDateKey,NSURLIsDirectoryKey,NSURLIsHiddenKey,NSURLThumbnailDictionaryKey,NSURLTypeIdentifierKey]
        if let fromDirectoryPath = path(){
            do{
                if let listOfFolders = try fileManager.contentsOfDirectoryAtPath(fromDirectoryPath as String) as NSArray?{
                    if let suffex = folderName{
                        let predicate = NSPredicate(format: "SELF CONTAINS[c] '\(suffex)'")
                        let filteredList = listOfFolders.filteredArrayUsingPredicate(predicate) as NSArray
                        folders = getFolders(filteredList as! [String])
                    }
                    else{
                        folders = getFolders(listOfFolders as! [String])
                    }
                }
            } catch let error as NSError{
                print("Error \(error.debugDescription)")
            }
        }
        return folders
    }
    
    func files(searchBy extention: String? = nil) -> [IDNFile]{
        //
        var documents = [IDNFile]()
        if let fromDirectoryPath = path(){
            do{
                if let listOfFiles = try fileManager.contentsOfDirectoryAtPath(fromDirectoryPath as String) as NSArray?{
                    if let suffex = extention{
                        let predicate = NSPredicate(format: "SELF CONTAINS[c] '\(suffex)'")
                        let filteredList = listOfFiles.filteredArrayUsingPredicate(predicate) as NSArray
                        documents = getFiles(filteredList as! [String])
                    }
                    else{
                        documents = getFiles(listOfFiles as! [String])
                    }
                }
            } catch let error as NSError{
                print("Error \(error.debugDescription)")
            }
        }
        return documents
    }
    
    //MARK: Public pretty operations
    
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
    
    final func resolveChildName(name oldName: String) -> String{
        //
        let onlyName = (oldName as NSString).stringByDeletingPathExtension
        let extention = (oldName as NSString).pathExtension
        if (extention.characters.count > 0){
            var newName = recursivelyResolveChildName(name: onlyName, newName: onlyName, extention: extention)
            newName = "\(newName).\(extention)"
            return newName
        }
        else{
            let newName = recursivelyResolveChildName(name: onlyName, newName: onlyName)
            return newName
        }
    }
    
    func contains(fileOrFolder name: String?) -> (Bool, NSString?){
        //
        if let content = name{
            if let filePath = contentPath(content: content){
                let isTrue = fileManager.fileExistsAtPath(filePath as String)
                return (isTrue, filePath)
            }
        }
        return (false, nil)
    }
    
    func allContents(searchBy name: String? = nil) -> (folders: [IDNFolder], files: [IDNFile]){
        //
        let _files = files(searchBy: name)
        let _folders = subfolders(searchBy: name)
        return (_folders, _files)
    }
    
    //MARK: some unnecessary file operation
    
    func saveAs(fileName: String, data: NSData, replace: Bool = true) -> (Bool, NSURL?){
        //
        if !exist(){
            return (false, nil)
        }
        if (replace){
            if removeBy(fileName){
                messageLogger("saveAs", message: "\(fileName) has removed")
            }
        }
        let finalName = resolveChildName(name: fileName)
        let path = contentPath(content: finalName)
        let url = NSURL(fileURLWithPath: path! as String)
        let saveAsFile = DNFile(url: url)
        let isCreated = saveAsFile.write(data)
        return (isCreated, url)
    }
    
    func paste(content file: IDNFile, replace: Bool = true) -> (Bool, NSURL?){
        //
        if (exist() == false && file.fileExist() == false && file.isFile() == false){
            return (false, nil)
        }
        if (replace){
            if removeBy(file.name){
                messageLogger("paste", message: "\(file.name) has removed")
            }
        }
        let finalName = resolveChildName(name: file.name)
        let path = contentPath(content: finalName)
        let url = NSURL(fileURLWithPath: path! as String)
        let pastedFile = DNFile(url: url)
        if let writable = file.read(){
            let isDone = pastedFile.write(writable)
            return (isDone, url)
        }
        return (false, nil)
    }
    
    func delete(contentByName name: String) -> Bool{
        return removeBy(name)
    }
    
    func delete(content file: IDNFile) -> Bool{
        return removeBy(file.name)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////
    
    private func recursivelyResolveChildName(name oldName: String, newName: String, extention: String? = nil, count: Int = 2) -> String{
        //
        let isExist: (exist: Bool, path: NSString?) = (extention == nil) ? contains(fileOrFolder: newName) : contains(fileOrFolder: "\(newName).\(extention!)")
        if isExist.exist == false{
            return newName
        }
        else{
            let newName = "\(oldName) \(count)"
            let xCount = count + 1
            return recursivelyResolveChildName(name: oldName, newName: newName, extention: extention, count: xCount)
        }
    }
    
    private func getFolders(listOfFolders: [String]) -> [IDNFolder]{
        //
        var folders = [IDNFolder]()
        for folderName in listOfFolders{
            let folder = subfolder(byName: folderName)
            if folder.isFolder(){
                folders.append(folder)
            }
        }
        return folders
    }
    
    private func getFiles(listOfFiles: [String]) -> [IDNFile]{
        //
        var documents = [IDNFile]()
        for fileName in listOfFiles{
            let url = NSURL(fileURLWithPath: contentPath(content: fileName)! as String)
            let file = DNFile(url: url)
            if file.isFile(){
                documents.append(file)
            }
        }
        return documents
    }
    
    private func contentPath(content fileName: String) -> NSString?{
        //
        let rootPath = path()
        let finalPath = rootPath?.stringByAppendingPathComponent(fileName)
        return finalPath
    }
    
    private func removeFrom(filePath: String) -> Bool{
        //
        let url = NSURL(fileURLWithPath: filePath)
        let isRemoved: Bool
        do {
            try fileManager.removeItemAtURL(url)
            isRemoved = true
        } catch let error as NSError {
            isRemoved = false
            errorLogger("removeFrom", error: error)
        }
        return isRemoved
    }
    
    private func removeBy(fileName: String?) -> Bool{
        //
        let isExist: (exist: Bool, path: NSString?) = contains(fileOrFolder: fileName)
        if isExist.exist{
            let isRemoved = removeFrom(isExist.path! as String)
            if isRemoved{
                messageLogger("delete", message: "\(fileName) deleted")
            }
            return isRemoved
        }
        return isExist.exist
    }
}
