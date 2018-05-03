//
//  KGAsynchImage.h
//  SampleAllProjects
//
//  Created by Towhidul Islam on 11/13/17.
//  Copyright © 2017 KITE GAMES STUDIO. All rights reserved.
//

#import <CoreDataStack/CoreDataStack.h>
NS_ASSUME_NONNULL_BEGIN
@interface AsynchImage : NGObject
@property (nonatomic, copy) NSString *imageLink;
- (instancetype) initWithLink:(NSString*)link;
- (void) fetch:(void(^ _Nullable)(UIImage* _Nullable))handler;
- (void) fetchWithSize:(CGSize)size completion:(void(^ _Nullable)(UIImage* _Nullable))handler;
@end
NS_ASSUME_NONNULL_END
