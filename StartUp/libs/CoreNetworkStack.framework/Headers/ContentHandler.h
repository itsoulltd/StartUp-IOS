//
//  RemoteObjectProgressHandler.h
//  RequestSynchronizer
//
//  Created by Towhid Islam on 7/28/14.
//  Copyright (c) 2014 Towhid Islam. All rights reserved.
//

@import CoreDataStack;

@interface ContentHandler : NGObject
@property (nonatomic, copy) NSString *mimeType;
@property (nonatomic, copy) NSString *textEncodingName;
@property (nonatomic, copy) NSString *suggestedFileName;
@property (nonatomic, assign) unsigned long long expectedLength;
@property (nonatomic, assign) unsigned long long totalByteRW;
@property (nonatomic, assign) unsigned long long totalBytesExpectedToRW;
@property (nonatomic, assign) unsigned long byteReceived;
- (float) calculatePercentage:(unsigned long)length;
- (void) resetWithExpectedLength:(unsigned long long)expectedLength;
- (void) resetWithResponse:(NSHTTPURLResponse*)response;
@end
