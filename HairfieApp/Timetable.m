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

    for (NSString *dayOfWeek in @[@"MON", @"TUE", @"WED", @"THU", @"FRI", @"SAT", @"SUN"]) {
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
                      wednesday:[temp objectForKey:@"WED"]
                       thursday:[temp objectForKey:@"THU"]
                         friday:[temp objectForKey:@"FRI"]
                       saturday:[temp objectForKey:@"SAT"]
                         sunday:[temp objectForKey:@"SUN"]];
}

-(id)initWithMonday:(NSArray *)aMonday
            tuesday:(NSArray *)aTuesday
          wednesday:(NSArray *)aWednesday
           thursday:(NSArray *)aThursday
             friday:(NSArray *)aFriday
           saturday:(NSArray *)aSaturday
             sunday:(NSArray *)aSunday
{
    self = [super init];
    if (self) {
        self.monday = (NSMutableArray*)aMonday; // TODO: make them imutable
        self.tuesday = (NSMutableArray*)aTuesday;
        self.wednesday = (NSMutableArray*)aWednesday;
        self.thursday = (NSMutableArray*)aThursday;
        self.friday = (NSMutableArray*)aFriday;
        self.saturday = (NSMutableArray*)aSaturday;
        self.sunday = (NSMutableArray*)aSunday;
    }
    return self;
}

-(id)initEmpty // TODO: override init instead?
{
    self = [super init];
    if (self) {
        self.monday = [[NSMutableArray alloc] init]; // TODO: make them imutable
        self.tuesday = [[NSMutableArray alloc] init];
        self.wednesday = [[NSMutableArray alloc] init];
        self.thursday = [[NSMutableArray alloc] init];
        self.friday = [[NSMutableArray alloc] init];
        self.saturday = [[NSMutableArray alloc] init];
        self.sunday = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)addTimeWindow:(TimeWindow *)timewindow toDayInteger:(NSInteger)integer {
    if (integer == 0) {
        [self.monday addObject:timewindow];
    } else if (integer == 1) {
        [self.tuesday addObject:timewindow];
    } else if (integer == 2) {
        [self.wednesday addObject:timewindow];
    } else if (integer == 3) {
        [self.thursday addObject:timewindow];
    } else if (integer == 4) {
        [self.friday addObject:timewindow];
    } else if (integer == 5) {
        [self.saturday addObject:timewindow];
    } else if (integer == 6) {
        [self.sunday addObject:timewindow];
    }
}

-(void)clearDayInteger:(NSInteger)integer {
    if (integer == 0) {
        [self.monday removeAllObjects];
    } else if (integer == 1) {
        [self.tuesday removeAllObjects];
    } else if (integer == 2) {
        [self.wednesday removeAllObjects];
    } else if (integer == 3) {
        [self.thursday removeAllObjects];
    } else if (integer == 4) {
        [self.friday removeAllObjects];
    } else if (integer == 5) {
        [self.saturday removeAllObjects];
    } else if (integer == 6) {
        [self.sunday removeAllObjects];
    }
}

-(NSDictionary*) toDictionary
{
    return @{
        @"MON": [self timeWindowsToDictionaries:self.monday],
        @"TUE": [self timeWindowsToDictionaries:self.tuesday],
        @"WED": [self timeWindowsToDictionaries:self.wednesday],
        @"THU": [self timeWindowsToDictionaries:self.thursday],
        @"FRI": [self timeWindowsToDictionaries:self.friday],
        @"SAT": [self timeWindowsToDictionaries:self.saturday],
        @"SUN": [self timeWindowsToDictionaries:self.sunday]
    };
}


-(NSArray *)timeWindowsToDictionaries:(NSArray *)timeWindows
{
    NSMutableArray *tmp = [[NSMutableArray alloc] init];

    for (TimeWindow *timeWindow in timeWindows) {
        [tmp addObject:[timeWindow toDictionary]];
    }

    return [[NSArray alloc] initWithArray:tmp];
}

-(BOOL)isOpenToday
{
    NSDate *now = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSWeekdayCalendarUnit fromDate:now];

    NSArray *timeWindows = nil;
    switch ([components weekday]) {
        case 1:
            timeWindows = self.sunday;
            break;
        case 2:
            timeWindows = self.monday;
            break;
        case 3:
            timeWindows = self.tuesday;
            break;
        case 4:
            timeWindows = self.wednesday;
            break;
        case 5:
            timeWindows = self.thursday;
            break;
        case 6:
            timeWindows = self.friday;
            break;
        case 7:
            timeWindows = self.saturday;
            break;
        default:
            [[[NSException alloc] initWithName:@"Invalid week day"
                                        reason:[NSString stringWithFormat:@"Got week day: %@", [components weekday]]
                                      userInfo:nil] raise];
    }

    return timeWindows.count > 0;
}

@end
