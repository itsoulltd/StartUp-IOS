//
//  StoreShelfItem.h
//  Prokasona
//
//  Created by Towhid Islam on 7/1/13.
//  Copyright (c) 2013 Towhid Islam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DNObject.h"

@interface DNStoreItem : DNObject
@property (nonatomic, strong) NSString *Identifier;
- (instancetype) initWithIdentifier:(NSString*)identifier;
@end
