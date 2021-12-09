//
//  CryptoFile.h
//  CryptoFile
//
//  Created by Towhidul Islam on 6/21/18.
//  Copyright (c) 2017 Next Generation Object Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IFile;
@protocol IFileProgress;

@interface CryptoFile : NSObject <IFile>
- (instancetype) initWithFile:(id<IFile>)file;
- (instancetype) initWithUrl:(NSURL*)url;
- (void) encryptFrom:(id<IFile>)readfile bufferSize:(int)size password:(NSString*)key progress:(id<IFileProgress>)prog completionHandler:(void(^)(BOOL))handler;
- (void) encrypt:(NSString*)key bufferSize:(int)size progress:(id<IFileProgress>)prog completionHandler:(void(^)(NSData*))handler;
- (void) decryptTo:(id<IFile>)file bufferSize:(int)size password:(NSString*)key progress:(id<IFileProgress>)prog completionHandler:(void(^)(BOOL))handler;
- (void) decrypt:(NSString*)key bufferSize:(int)size progress:(id<IFileProgress>)prog completionHandler:(void(^)(NSData*))handler;
@end
