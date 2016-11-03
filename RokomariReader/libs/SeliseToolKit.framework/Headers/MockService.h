//
//  MockService.h
//  RequestSynchronizer
//
//  Created by Towhid on 8/27/14.
//  Copyright (c) 2014 Towhid Islam. All rights reserved.
//

#import "RemoteService.h"

struct RandRange {
    u_int32_t min, max;
};
typedef struct RandRange RandRange;


@interface MockService : RemoteService
@property (nonatomic) RandRange range;
/*!
 * DataSet should Dictionary
 */
- (void) mockDataSet:(NSArray*)dataSet;
/*!
 * DataSet file should be plist file
 */
- (void) mockDataSetFilePath:(NSURL*)dataSetPath;
@end
