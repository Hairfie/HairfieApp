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
        self.monday = (NSMutableArray*)aMonday;
        self.tuesday = (NSMutableArray*)aTuesday;
        self.thursday = (NSMutableArray*)aThursday;
        self.wednesday = (NSMutableArray*)aWednesday;
        self.friday = (NSMutableArray*)aFriday;
        self.saturday = (NSMutableArray*)aSaturday;
        self.sunday = (NSMutableArray*)aSunday;
    }
    return self;
}

-(id)initEmpty
{
    self = [super init];
    
        self.monday = [[NSMutableArray alloc] init];
        self.tuesday = [[NSMutableArray alloc] init];
        self.thursday = [[NSMutableArray alloc] init];
        self.wednesday = [[NSMutableArray alloc] init];
        self.friday = [[NSMutableArray alloc] init];
        self.saturday = [[NSMutableArray alloc] init];
        self.sunday = [[NSMutableArray alloc] init];
    return self;
}

-(NSDictionary*) toDictionary
{
 
    NSMutableArray *montmp = [self timetableElementToMutableArray:self.monday];
    NSMutableArray *tuetmp = [self timetableElementToMutableArray:self.tuesday];
    NSMutableArray *wedtmp = [self timetableElementToMutableArray:self.wednesday];
    NSMutableArray *thutmp = [self timetableElementToMutableArray:self.thursday];
    NSMutableArray *fritmp = [self timetableElementToMutableArray:self.friday];
    NSMutableArray *sattmp = [self timetableElementToMutableArray:self.saturday];
    NSMutableArray *suntmp = [self timetableElementToMutableArray:self.sunday];
    
    
    return [[NSDictionary alloc] initWithObjectsAndKeys:montmp, @"MON", tuetmp, @"TUE", wedtmp, @"WED", thutmp, @"THU",fritmp, @"FRI", sattmp, @"SAT", suntmp, @"SUN", nil];
}


-(NSMutableArray*)timetableElementToMutableArray:(NSMutableArray*)day
{
    NSMutableArray *tmp = [[NSMutableArray alloc] init];
    
    for (TimeWindow *tm in day)
    {
        [tmp addObject:[tm toDictionary]];
    }
    
    return tmp;
}

@end
