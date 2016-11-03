//
//  DNSecureFile.swift
//  StartupProjectSampleA
//
//  Created by Towhid on 8/26/15.
//  Copyright (c) 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation

class DNSecureFile: DNFile {
    
    func decrypt(password key: String, var bufferSize: Int = 1024, progress: IDNFileProgress? = nil, completionHandler: ((NSData)->Void)? = nil){
        //Following Code is copied from https://github.com/RNCryptor/RNCryptor#async-and-streams
        //As Suggested by RNCrypto framework auther -> How to use encryption/decryption with RNCrypto API.
        //Actual code was written in Objective-C. Here we have converted into Swift.
        //Please, feel free to Copy/Modify folloing lines of code. RNCrypto API is MIT License.
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
            //
            if bufferSize < 1024{
                bufferSize = 1024
            }
            let blockSize = 2 * bufferSize
            let readStream: NSInputStream = NSInputStream(fileAtPath: self.URL.path!)!
            let writeBuffer: NSMutableData = NSMutableData()
            
            readStream.open()
            
            let data = NSMutableData(length: blockSize)!
            var decryptor: RNDecryptor? = nil
            var totalWritenLength: Int = 0
            
            let readStreamBlock: dispatch_block_t = { (Void) -> Void in
                data.length = blockSize
                let buffer = UnsafeMutablePointer<UInt8>(data.mutableBytes)
                let bytesRead = readStream.read(buffer, maxLength: blockSize)
                if bytesRead == 0{
                    readStream.close()
                    decryptor?.finish()
                }
                else if bytesRead > 0{
                    totalWritenLength += bytesRead
                    data.length = bytesRead
                    decryptor?.addData(data)
                    //println("Sent \(bytesRead) bytes to decryptor.")
                }
                else{
                    print("Error Has Occoured In DNFile.secureWrite(from:bufferSize:password:completionHandler:) method.")
                    if let completion = completionHandler{
                        completion(writeBuffer)
                    }
                }
            }
            
            decryptor = RNCryptorHelper.decryptorWithKey(key, handler: { (cryptor: RNCryptor!, data: NSData!) -> Void in
                //
                //println("Encryptor received \(data.length) bytes.")
                let buffer = UnsafePointer<UInt8>(data.bytes)
                writeBuffer.appendBytes(buffer, length: data.length)
                if cryptor.finished{
                    if let completion = completionHandler{
                        completion(writeBuffer)
                    }
                }
                else{
                    self.calculateProgress(totalReadWrite: totalWritenLength, totalDataLength: self.sizeInBytes, progress: progress)
                    readStreamBlock()
                }
            })
            
            readStreamBlock()
        })
    }
    
    func decrypt(to file: IDNFile, var bufferSize: Int, password key: String, progress: IDNFileProgress?, completionHandler: ((Bool) -> Void)? = nil){
        //Following Code is copied from https://github.com/RNCryptor/RNCryptor#async-and-streams
        //As Suggested by RNCrypto framework auther -> How to use encryption/decryption with RNCrypto API.
        //Actual code was written in Objective-C. Here we have converted into Swift.
        //Please, feel free to Copy/Modify folloing lines of code. RNCrypto API is MIT License.
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
            //
            if bufferSize < 1024{
                bufferSize = 1024
            }
            let blockSize = 2 * bufferSize
            let readStream: NSInputStream = NSInputStream(fileAtPath: self.URL.path!)!
            let writeStream: NSOutputStream = NSOutputStream(toFileAtPath: file.URL.path!, append: false)!
            
            readStream.open()
            writeStream.open()
            
            let data = NSMutableData(length: blockSize)!
            var decryptor: RNDecryptor? = nil
            var totalWritenLength: Int = 0
            let readFileTotalBytes = self.sizeInBytes
            
            let readStreamBlock: dispatch_block_t = { (Void) -> Void in
                data.length = blockSize
                let buffer = UnsafeMutablePointer<UInt8>(data.mutableBytes)
                let bytesRead = readStream.read(buffer, maxLength: blockSize)
                if bytesRead == 0{
                    readStream.close()
                    decryptor?.finish()
                }
                else if bytesRead > 0{
                    totalWritenLength += bytesRead
                    data.length = bytesRead
                    decryptor?.addData(data)
                    //println("Sent \(bytesRead) bytes to encryptor.")
                }
                else{
                    print("Error Has Occoured In DNFile.secureWrite(from:bufferSize:password:completionHandler:) method.")
                    if let completion = completionHandler{
                        completion(false)
                    }
                }
            }
            
            decryptor = RNCryptorHelper.decryptorWithKey(key, handler: { (cryptor: RNCryptor!, data: NSData!) -> Void in
                //
                //println("Encryptor received \(data.length) bytes.")
                let buffer = UnsafePointer<UInt8>(data.bytes)
                writeStream.write(buffer, maxLength: data.length)
                if cryptor.finished{
                    writeStream.close()
                    if let completion = completionHandler{
                        completion(true)
                    }
                }
                else{
                    self.calculateProgress(totalReadWrite: totalWritenLength, totalDataLength: readFileTotalBytes, progress: progress)
                    readStreamBlock()
                }
            })
            
            readStreamBlock()
        })
    }
    
    func secureWrite(from readfile: IDNFile, var bufferSize: Int = 1024, password key: String, progress: IDNFileProgress? = nil, completionHandler: ((Bool)->Void)? = nil){
        //Following Code is copied from https://github.com/RNCryptor/RNCryptor#async-and-streams
        //As Suggested by RNCrypto framework auther -> How to use encryption/decryption with RNCrypto API.
        //Actual code was written in Objective-C. Here we have converted into Swift.
        //Please, feel free to Copy/Modify folloing lines of code. RNCrypto API is MIT License.
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
            //
            if (self.fileExist()){
                self.delete()
            }
            if bufferSize < 1024{
                bufferSize = 1024
            }
            let blockSize = 2 * bufferSize
            let readStream: NSInputStream = NSInputStream(fileAtPath: readfile.URL.path!)!
            let writeStream: NSOutputStream = NSOutputStream(toFileAtPath: self.URL.path!, append: false)!
            
            readStream.open()
            writeStream.open()
            
            let data = NSMutableData(length: blockSize)!
            var encryptor: RNEncryptor? = nil
            var totalWritenLength: Int = 0
            let readFileTotalBytes = readfile.sizeInBytes
            
            let readStreamBlock: dispatch_block_t = { (Void) -> Void in
                data.length = blockSize
                let buffer = UnsafeMutablePointer<UInt8>(data.mutableBytes)
                let bytesRead = readStream.read(buffer, maxLength: blockSize)
                if bytesRead == 0{
                    readStream.close()
                    encryptor?.finish()
                }
                else if bytesRead > 0{
                    totalWritenLength += bytesRead
                    data.length = bytesRead
                    encryptor?.addData(data)
                    //println("Sent \(bytesRead) bytes to encryptor.")
                }
                else{
                    print("Error Has Occoured In DNFile.secureWrite(from:bufferSize:password:completionHandler:) method.")
                    if let completion = completionHandler{
                        completion(false)
                    }
                }
            }
            
            encryptor = RNCryptorHelper.encryptorWithKey(key, handler: { (cryptor: RNCryptor!, data: NSData!) -> Void in
                //
                //println("Encryptor received \(data.length) bytes.")
                let buffer = UnsafePointer<UInt8>(data.bytes)
                writeStream.write(buffer, maxLength: data.length)
                if cryptor.finished{
                    writeStream.close()
                    if let completion = completionHandler{
                        completion(true)
                    }
                }
                else{
                    self.calculateProgress(totalReadWrite: totalWritenLength, totalDataLength: readFileTotalBytes, progress: progress)
                    readStreamBlock()
                }
            })
            
            readStreamBlock()
        })
        
    }
    
}
