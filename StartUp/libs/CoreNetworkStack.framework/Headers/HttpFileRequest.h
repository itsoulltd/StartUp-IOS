//
//  NetCapsulBinary.h
//  RequestSynchronizer
//
//  Created by NGStack on 4/30/14.
//  Copyright (c) 2014 Towhid Islam. All rights reserved.
//

#import "HttpWebRequest.h"

@interface HttpFileRequest : HttpWebRequest
@property (nonatomic, strong) NSURL *localFileURL;
@property (nonatomic, strong) NSString *dispositionName;
- (instancetype) initWithBaseUrl:(NSString*)baseUrl method:(HTTP_METHOD)httpMethod;
- (NSURLRequest*) createThinRequest;
- (NSURLRequest*) createRequestWithPathComponent:(NSArray*)pathComponent payload:(id<NGObjectProtocol>)payload fileData:(NSData*)data dispositionName:(NSString*)name fileName:(NSString*)filename;
- (NSURLRequest*) createRequestWithPathComponent:(NSArray*)pathComponent payload:(id<NGObjectProtocol>)payload localFileUrl:(NSURL*)fileURL dispositionName:(NSString*)name;
- (NSNumber*) getLocalFileSize;
- (NSData*) getLocalFileData;
- (NSData*) getHTTPBodyData;
- (NSInputStream*) getHTTPBodyStream;
@end
