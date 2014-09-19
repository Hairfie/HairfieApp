//
//  Timetable.m
//  HairfieApp
//
//  Created by Antoine Hérault on 19/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "Timetable.h"
#import "TimeWindow.h"

@implementation Timetable

-(id)initWithDictionary:(NSDictionary *)aDictionary
{
    NSMutableDictionary *temp = [[NSMutableDictionary alloc] initWithDictionary:aDictionary];
    
    for (NSString *dayOfWeek in @[@"MON", @"TUE", @"THU", @"WED", @"FRI", @"SAT", @"SUN"]) {
        NSArray *dayArray = [aDictionary objectForKey:dayOfWeek];
        if (nil == dayArray) {
            dayArray = @[];
        }
        
        NSMutableArray *dayTimeWindows = [[NSMutableArray alloc] init];
        for (NSDictionary *timeWindowDic in dayArray) {
            [dayTimeWindows addObject:[[TimeWindow alloc] initWithDictionary:timeWindowDic]];
        }
        
        [temp setObject:dayTimeWindows forKey:dayOfWeek];
    }
    
    return [self initWithMonday:[temp objectForKey:@"MON"]
                        tuesday:[temp objectForKey:@"TUE"]
                       thursday:[temp objectForKey:@"THU"]
                      wednesday:[temp objectForKey:@"WED"]
                         friday:[temp objectForKey:@"FRI"]
                       saturday:[temp objectForKey:@"SAT"]
                         sunday:[temp objectForKey:@"SUN"]];
}

-(id)initWithMonday:(NSArray *)aMonday
            tuesday:(NSArray *)aTuesday
           thursday:(NSArray *)aThursday
          wednesday:(NSArray *)aWednesday
             friday:(NSArray *)aFriday
           saturday:(NSArray *)aSaturday
             sunday:(NSArray *)aSunday
{
    self = [super init];
    if (self) {
        self.monday = aMonday;
        self.tuesday = aTuesday;
        self.thursday = aThursday;
        self.wednesday = aWednesday;
        self.friday = aFriday;
        self.saturday = aSaturday;
        self.sunday = aSunday;
    }
    return self;
}

@end
