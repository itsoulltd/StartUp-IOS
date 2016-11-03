//
//  SeliseToolKit.h
//  SeliseToolKit
//
//  Created by Towhid Islam on 9/6/14.
//  Copyright (c) 2014 Towhid Islam. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for SeliseToolKit.
FOUNDATION_EXPORT double SeliseToolKitVersionNumber;

//! Project version string for SeliseToolKit.
FOUNDATION_EXPORT const unsigned char SeliseToolKitVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <SeliseToolKit/PublicHeader.h>

//#import <SeliseToolKit/>

//CoreCommunication headers (Foundation, UIKit and SystemConfiguration(SCNetwork) dependency)
#import <SeliseToolKit/CommunicationHeader.h>
#import <SeliseToolKit/ContentProgressDelegate.h>
#import <SeliseToolKit/RemoteConnection.h>
#import <SeliseToolKit/ConnectionDelegateHandler.h>
#import <SeliseToolKit/DNRequest.h>
#import <SeliseToolKit/DNFileUploadRequest.h>
#import <SeliseToolKit/HttpRequestHeader.h>
#import <SeliseToolKit/RemoteServiceProtocol.h>
#import <SeliseToolKit/RemoteService.h>
#import <SeliseToolKit/FailureMessage.h>
#import <SeliseToolKit/MockService.h>
#import <SeliseToolKit/NetworkActivityController.h>
#import <SeliseToolKit/RemoteTask.h>
#import <SeliseToolKit/RemoteSessionProtocol.h>
#import <SeliseToolKit/SessionDelegateHandler.h>
#import <SeliseToolKit/RemoteSession.h>
#import <SeliseToolKit/EnergyStateSession.h>
//Utility Headers (CoreLocation,)
#import <SeliseToolKit/PropertyList.h>
#import <SeliseToolKit/ApplicationFileManager.h>
#import <SeliseToolKit/ArrayUtility.h>
#import <SeliseToolKit/Stack.h>
#import <SeliseToolKit/Queue.h>
#import <SeliseToolKit/DebugLog.h>
#import <SeliseToolKit/ExceptionLog.h>
#import <SeliseToolKit/LogTracker.h>
#import <SeliseToolKit/ColorBank.h>

//CoreData headers (CoreData dependency)
#import <SeliseToolKit/DNObjectContext.h>
#import <SeliseToolKit/DNKeyedContext.h>
#import <SeliseToolKit/DNManagedObjectProtocol.h>
#import <SeliseToolKit/DNManagedObject.h>
#import <SeliseToolKit/DNCoreObject.h>
//BaseModel Object Headers
#import <SeliseToolKit/DNObjectProtocol.h>
#import <SeliseToolKit/DNObject.h>

//Hashing Algo for NSString and NSData
#import <SeliseToolKit/NSString+Hash.h>
#import <SeliseToolKit/NSData+Hash.h>

//PurchaseManager
#import <SeliseToolKit/DNStoreItem.h>
#import <SeliseToolKit/DNPurchaseManager.h>


//Color keys, which have to use with ColorBank "+colorForkey:".
//There are lots more, almost 141 color name and their hexa value in the list.
//The list was copied from http://www.w3schools.com/tags/ref_color_tryit.asp?
//Please visit that link to find more color keys.
#define AliceBlue @"AliceBlue"
#define Aqua @"Aqua"
#define Aquamarine @"Aquamarine"
#define MediumAquaMarine @"MediumAquaMarine"
#define Black @"Black"
#define Blue @"Blue"
#define Brown @"Brown"
#define Cyan @"Cyan"
#define Gray @"Gray"
#define Green @"Green"
#define Orange @"Orange"
#define Pink @"Pink"
#define Purple @"Purple"
#define Red @"Red"
#define Silver @"Silver"
#define White @"White"
#define Yellow @"Yellow"
#define Gold @"Gold"
#define LightGoldenRodYellow @"LightGoldenRodYellow"
