//
//  UploadOperationGroup.h
//  NGAppKit
//
//  Created by Towhid Islam on 6/8/17.
//  Copyright © 2017 Towhidul Islam. All rights reserved.
//

#import <CoreDataStack/CoreDataStack.h>

@class OperationGroup;

@protocol OperationGroupDelegate <NSObject>

- (void) operationGroupDidFinish:(NSString*)identifier;

@end

@interface OperationGroup : NGObject
@property (nonatomic, weak) id<OperationGroupDelegate> delegate;
- (NSString*) identifier;
- (void) cancel;
- (void) attachProgressBlock:(void(^)(double))progress;
- (void) enqueueIntoQueue:(NSOperationQueue*)queue;
@end
