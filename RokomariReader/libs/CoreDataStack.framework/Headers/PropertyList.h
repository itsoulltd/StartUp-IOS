//
//  CollectionPersistManager.h
//  ContrinerViewSample
//
//  Created by Towhidul Islam on 4/1/14.
//  Copyright (c) 2017 Next Generation Object Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PropertyList : NSObject

- (instancetype) initWithFileName:(NSString*)fileName directoryType:(NSSearchPathDirectory)directory dictionary:(BOOL)isDictionary;
/*!
 * return collection a immutable collection
 */
- (id) readOnlyCollection;
/*!
 * item could be an array-item for the array or a dictionary-item for dictinary
 */
- (void) addItemToCollection:(id)item;
/*!
 * items have to be an array
 */
- (void) addItemsToCollection:(NSArray*)items;
/*!
 * when collection is dectionary then this methods works
 */
- (void) addItemToCollection:(id)item forKey:(id<NSCopying>)key;
/*!
 * remove only the specific item matched at least
 */
- (void) removeItemFromCollection:(id)item;
/*!
 * remove only the specific items matched
 */
- (void) removeItemsFromCollection:(NSArray*)items;
/*!
 * remove only the specific item matched with key
 */
- (void) removeItemFromCollectionForKey:(id<NSCopying>)key;
/*!
 * remove only the specific items matched with keys
 */
- (void) removeItemsFromCollectionForKeys:(NSArray*)keys;
/*!
 *
 */
- (id) itemAtIndex:(NSInteger)index;
/*!
 *
 */
- (id) itemForKey:(id<NSCopying>)key;
/*!
 *
 */
- (BOOL) save;
/*!
 * save in background thread
 */
- (void) saveBackground;
/*!
 *
 */
- (NSURL*) storageLocation;
@end
