//
//  TimeWindow.m
//  HairfieApp
//
//  Created by Antoine Hérault on 19/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "TimeWindow.h"

@implementation TimeWindow

-(id)initWithDictionary:(NSDictionary *)aDictionary
{
    return [self initWithStartTime:[aDictionary objectForKey:@"startTime"]
                           endTime:[aDictionary objectForKey:@"endTime"]
                   appointmentMode:[aDictionary objectForKey:@"appointmentMode"]];
}

-(id)initWithStartTime:(NSString *)aStartTime
               endTime:(NSString *)anEndTime
       appointmentMode:(NSString *)anAppointmentMode
{
    self = [super init];
    if (self) {
        self.startTime = aStartTime;
        self.endTime = anEndTime;
        self.appointmentMode = anAppointmentMode;
    }
    return self;
}

-(NSString *)timeWindowFormatted
{
    return [NSString stringWithFormat:@"%@ - %@", self.startTime, self.endTime];
}

-(NSDictionary*)toDictionary
{
    return [[NSDictionary alloc] initWithObjectsAndKeys:self.startTime,@"startTime", self.endTime, @"endTime", nil];
}




@end