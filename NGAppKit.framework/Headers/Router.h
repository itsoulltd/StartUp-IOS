//
//  Router.h
//  NGAppKit
//
//  Created by Towhidul Islam on 11/29/17.
//  Copyright © 2017 ITSoulLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreDataStack/NGObject.h>
#import "RouterProtocol.h"

@interface RouteTo: NGObject
@property (nonatomic, copy) NSString * _Nonnull storyboard;
@property (nonatomic, copy) NSString * _Nonnull viewControllerID;
@property (nonatomic, copy) NSString * _Nullable viewControllerIPadID;
@end

NS_ASSUME_NONNULL_BEGIN
@interface Router : NSObject <RouterProtocol>
- (instancetype) initWithNext:(id<RouterProtocol> _Nullable)next;
- (UIViewController*) createRouteToViewController:(RouteTo*)info;
@end
NS_ASSUME_NONNULL_END
