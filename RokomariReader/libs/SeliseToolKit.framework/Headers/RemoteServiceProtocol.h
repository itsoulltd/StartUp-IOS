//
//  DyanaServiceProtocol.h
//  RequestSynchronizer
//
//  Created by Towhid Islam on 5/1/14.
//  Copyright (c) 2014 Towhid Islam. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FailureMessage;
@protocol RemoteServiceProtocol <NSObject>
@required
- (BOOL) validate:(id)info statusCode:(NSInteger)statusCode error:(NSError*)error;
- (FailureMessage*) serviceDidFailed:(id)info statusCode:(NSInteger)statusCode error:(NSError*)error;
@optional
- (NSArray*) serviceDidSucced:(id)info;
@end
