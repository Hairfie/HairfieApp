//
//  Timetable.h
//  HairfieApp
//
//  Created by Antoine Hérault on 19/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimeWindow.h"

@interface Timetable : NSObject

@property (strong, nonatomic) NSMutableArray *monday;
@property (strong, nonatomic) NSMutableArray *tuesday;
@property (strong, nonatomic) NSMutableArray *wednesday;
@property (strong, nonatomic) NSMutableArray *thursday;
@property (strong, nonatomic) NSMutableArray *friday;
@property (strong, nonatomic) NSMutableArray *saturday;
@property (strong, nonatomic) NSMutableArray *sunday;

-(id)initWithDictionary:(NSDictionary *)aDictionary;

-(void)addTimeWindow:(TimeWindow *)timewindow toDayInteger:(NSInteger)integer;
-(void)clearDayInteger:(NSInteger)integer;

-(id)initWithMonday:(NSArray *)aMonday
            tuesday:(NSArray *)aTuesday
          wednesday:(NSArray *)aWednesday
           thursday:(NSArray *)aThursday
             friday:(NSArray *)aFriday
           saturday:(NSArray *)aSaturday
             sunday:(NSArray *)aSunday;

-(id)initEmpty;
-(NSDictionary*) toDictionary;

-(BOOL)isOpenToday;

@end
