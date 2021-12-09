//
//  AppStoryboard.h
//  StartUpProject
//
//  Created by Towhidul Islam on 12/20/16.
//  Copyright © 2016 ITSoulLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppStoryboard : NSObject

+ (instancetype) load:(NSString*)name;

- (UIViewController*) initialViewController;

- (UIViewController*) viewControllerByType:(Class)type;

- (UIViewController*) viewControllerByStoryboardID:(NSString*)storyboardID;

+ (NSString*) resolveClassName:(Class)type;

+ (void)configureApplication:(UIApplication *)app mainBundle:(NSBundle*)main;

+ (UIViewController*) visibleViewController;

+ (void) showViewController:(UIViewController*)viewController sender:(id)sender;

+ (void) showModalViewController:(UIViewController*)viewController onCompletion:(void (^)(void))block;

+ (void) pushToLast:(UIViewController*)viewController sender:(id)sender;

+ (void) pushToLast:(UIViewController*)viewController replacing:(NSInteger)count sender:(id)sender;

@end
