//
//  FailureMessage.h
//  RequestSynchronizer
//
//  Created by Towhid on 9/4/14.
//  Copyright (c) 2014 Towhid Islam. All rights reserved.
//

#import "DNObject.h"
#import "CommunicationHeader.h"

@interface FailureMessage : DNObject
@property (nonatomic) NetworkOperationCode status;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;
@end
