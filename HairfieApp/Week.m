//
//  WeekDays.m
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 27/10/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "Week.h"
#import "Day.h"

@implementation Week

-(NSArray *)weekdays {
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
        NSDate *dayDate = [gregorian dateFromComponents:nowComponents];
        
        Day *day = [[Day alloc] initWithName:[[dateFormatter stringFromDate:dayDate] capitalizedString] andSelectorName:[[englishFormatter stringFromDate:dayDate] lowercaseString] andInt:[NSNumber numberWithInt:i]];

        [temp addObject:day];
    }

    NSArray *output = [[temp subarrayWithRange:NSMakeRange(1, 6)]
                    arrayByAddingObjectsFromArray:[temp subarrayWithRange:NSMakeRange(0,1)]];
    
    return output;
}

@end
