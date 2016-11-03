//
//  SLSAssetDirectoryController.h
//  VideoPlayerDemo
//
//  Created by Towhid Islam on 6/2/13.
//  Copyright (c) 2013 Secure Link Services Ltd(selise.ch). All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    UserDocumentDirectory,
    UserCacheDirectory
} DirectoryType;

@interface ApplicationFileManager : NSObject

//+ (SLSAssetDirectoryController*) sharedInstance;

/*!Save the given data to application document dir path with fileName and return saved file url
 \param data to be saved
 \param fileName
 \returns Url of saved paths
 */
+ (NSURL*) save:(NSData*)data toFileNamed:(NSString*)fileName;

/*!Save all key-valued fileName(key) TO DataSource(Value as NSData) INTO files passes as fileNames(Keys). allKeys in dictionary must be same
 as fileNames array. go through all files in the array and pick from dictionary and call save:toFileNamed: method
 \param list of filename as key and Data as value
 \param list of filename
 \return list of saved paths
 */
+ (NSDictionary*) save:(NSDictionary*)dataSources toFiles:(NSArray*)fileNames;

//Save the given data to application temp dir path with fileName
//and return saved file url
+ (NSURL *)cache:(NSData *)data toFileNamed:(NSString *)fileName;

//Save all key-valued fileName(key) TO DataSource(Value as NSData) INTO files passes as fileNames(Keys). allKeys in dictionary must be same
//as fileNames array. go through all files in the array and pick from dictionary and call save:toFileNamed: method
+ (NSDictionary*) cache:(NSDictionary*)dataSources toFiles:(NSArray*)fileNames;

//Move a file from filePath and copy to application document dir with newFileName(if already not exist,if so then return YES) and return YES,
//when old file remain same.
+ (BOOL) move:(NSURL*)filePath toLocation:(NSString*)newFileName;

//key-valued fileName(key) TO filePaths(Value as NSURL) INTO files passes as newFileNames(Keys). individual operation as same previous
+ (NSDictionary*) moves:(NSDictionary*)filePaths toLocations:(NSArray*)newFileNames;

//This time remove old one.
+ (BOOL) moveAndDispose:(NSURL*)filePath toLocation:(NSString*)newFileName;

// :)
+ (NSDictionary*) movesAndDisposes:(NSDictionary*)filePaths toLocations:(NSArray*)newFileNames;

//
+ (BOOL)disposeFile:(NSString*)fileName fromDirectory:(DirectoryType)type;

//Delete all files (as fileNames) to trash from application document directory.
+ (NSDictionary*) disposeFiles:(NSArray*)fileNames fromDirectory:(DirectoryType)type;

//Provide the string reprasentation of document directory appended by fileName
+ (NSString*) createDocumentPathWithFileName:(NSString*)fileName;

//Provide the string reprasentation of cache directory appended by fileName
+ (NSString*) createCachePathWithFileName:(NSString*)fileName;

//Provide the NSURL reprasentation of document directory appended by fileName
+ (NSURL*) createDocumentPathUrlWithFileName:(NSString*)fileName;

//Provide the NSURL reprasentation of cache directory appended by fileName
+ (NSURL*) createCachePathUrlWithFileName:(NSString*)fileName;

//return total space in bytes of User Document Directory
+ (unsigned long long) totalDocSizeInDirectory:(DirectoryType)type;

//
+ (unsigned long long) totalDocSizeExclude:(NSArray*)fileNames inDirectory:(DirectoryType)type;

//
+ (BOOL) isExist:(NSString*)fileName inDirectory:(DirectoryType)type;

@end
