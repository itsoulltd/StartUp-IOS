//
//  PurchaseManager.h
//  Prokasona
//
//  Created by Towhid Islam on 8/16/13.
//  Copyright (c) 2013 Towhid Islam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

extern NSString *const DNStoreKitProductInfoRetrivedNotification;

typedef NS_ENUM(NSInteger, TransactionType){
    Buy = 0,
    Restore = 1
};

@class DNStoreItem;
@protocol DNPurchaseManagerDelegate;
@protocol DNProductRequestDelegate;

@interface DNPurchaseManager : NSObject

+ (DNPurchaseManager*) sharedInstance;
@property (nonatomic, assign) id <DNPurchaseManagerDelegate> delegate;
@property (nonatomic, assign) id <DNProductRequestDelegate> requestDelegate;
- (void) requestToStoreWithIdentifiers:(NSArray*)identifiers;
- (NSNumber*) priceForProduct:(NSString*)identifier;
- (NSString*) printPriceForProduct:(NSString*)identifier;
- (void) buy:(DNStoreItem*)item;
- (BOOL) alreadyInQueue:(DNStoreItem*)item;
/*
 * key = appStorePurchaseIdentifier
 * value = instance of DNStoreItem
 */
- (void)restoreCompletedTransactions:(NSDictionary*)identifierToStoreId;
@end

@protocol DNPurchaseManagerDelegate <NSObject>
@required
- (void) transactionDidFinishForItem:(DNStoreItem*)item action:(TransactionType)type;
@optional
- (void) transactionDidFailedForItem:(DNStoreItem*)item;
@end

@protocol DNProductRequestDelegate <NSObject>
@required
- (void) responseForProduct:(SKProduct*)product withIdentifier:(NSString*)identifier;
@optional
- (void) responseFromStoreDidFailed;
@end

