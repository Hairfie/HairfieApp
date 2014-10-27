//
//  WeekDays.m
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 27/10/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "WeekDays.h"

@implementation WeekDays

-(NSArray *)all {
    NSDate *date = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setLocale:[NSLocale currentLocale]];
    
    NSDateComponents *nowComponents = [gregorian components:NSYearCalendarUnit | NSWeekCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    
    NSDateFormatter *englishFormatter = [[NSDateFormatter alloc] init];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [englishFormatter setLocale:usLocale];
    [englishFormatter setDateFormat:@"EEEE"];

    NSMutableArray *temp = [NSMutableArray array];
    
    for (int i = 1; i < 8; i++) {
        [nowComponents setWeekday:i];
        NSDate *day = [gregorian dateFromComponents:nowComponents];

        [temp addObject:@{
                          @"string"     : [[dateFormatter stringFromDate:day] capitalizedString],
                          @"int"        : [NSNumber numberWithInt:i],
                          @"selector"   : [[englishFormatter stringFromDate:day] lowercaseString]
                        }
         ];
    }
    NSUInteger firstWeekdayIndex = [gregorian firstWeekday];

    NSArray *output = [[temp subarrayWithRange:NSMakeRange(firstWeekdayIndex, 7-firstWeekdayIndex)]
                    arrayByAddingObjectsFromArray:[temp subarrayWithRange:NSMakeRange(0,firstWeekdayIndex)]];
    
    return output;
}

@end
