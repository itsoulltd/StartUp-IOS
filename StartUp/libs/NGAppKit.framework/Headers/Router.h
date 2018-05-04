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
@property (nonatomic, copy) NSString *storyboard;
@property (nonatomic, copy) NSString *viewControllerID;
@property (nonatomic, copy) NSString *viewControllerIPadID;
@end

@interface Router : NSObject <RouterProtocol>
- (instancetype) initWithNext:(id<RouterProtocol>)next;
- (UIViewController*) createRouteToViewController:(RouteTo*)info;
@end
