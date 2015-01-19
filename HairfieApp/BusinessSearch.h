//
//  BusinessSearch.h
//  HairfieApp
//
//  Created by Antoine Hérault on 06/10/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeoPoint.h"

@interface BusinessSearch : NSObject

@property (strong, nonatomic) NSString *query;
@property (strong, nonatomic) NSString *where;
@property (strong, nonatomic) NSArray *clientTypes;

-(NSString *)display;
-(NSString *)changedEventName;
-(GeoPoint *)whereGeoPoint;
-(BOOL)isAroundMe;

@end
