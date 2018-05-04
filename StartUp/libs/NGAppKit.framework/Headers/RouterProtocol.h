//
//  RouterProtocol.h
//  NGAppKit
//
//  Created by Towhidul Islam on 11/27/17.
//  Copyright © 2017 ITSoulLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreDataStack/CoreDataStack.h>
#ifndef RouterProtocol_h
#define RouterProtocol_h

extern NSString* _Nonnull const kRouteCount;

NS_ASSUME_NONNULL_BEGIN
@protocol RouterProtocol <UIViewControllerTransitioningDelegate, UINavigationControllerDelegate>
@required
- (void) routeFrom:(UIViewController*)viewController withInfo:(NGObject* _Nullable)info;
@optional
- (NGObject*) updateRoutingCount:(NGObject*)info;
-(void) routeFrom:(UIViewController*)viewController withInfo:(NGObject* _Nullable)info animated:(BOOL) animate onCompletion:(void(^)(void)) completion;
@end

@protocol UIRoutedViewControllerDelegate <NSObject>
@optional
- (void) routedViewController:(UIViewController*)routedVC viewDidAppear:(NGObject* _Nullable)info;
@end

NS_ASSUME_NONNULL_END
#endif /* RouterProtocol_h */
