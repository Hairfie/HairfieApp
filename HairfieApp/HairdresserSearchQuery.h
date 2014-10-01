//
//  HairdresserSearchQuery.h
//  HairfieApp
//
//  Created by Antoine Hérault on 01/10/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeoPoint.h"

@interface HairdresserSearchQuery : NSObject

@property (strong, nonatomic) NSString *query;
@property (strong, nonatomic) GeoPoint *location;

-(void)resultsWithLimit:(NSNumber *)aLimit
                   skip:(NSNumber *)aSkip
                success:(void(^)(NSArray *businesses))aSuccessHandler
                failure:(void(^)(NSError *error))aFailureHandler;

@end
