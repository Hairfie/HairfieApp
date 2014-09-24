//
//  TimeWindow.h
//  HairfieApp
//
//  Created by Antoine Hérault on 19/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeWindow : NSObject

@property (strong, nonatomic) NSString *startTime;
@property (strong, nonatomic) NSString *endTime;
@property (strong, nonatomic) NSString *appointmentMode; // OPTIONAL / REQUIRED / DISABLED / UNKNOWN

-(id)initWithDictionary:(NSDictionary *)aDictionary;

-(id)initWithStartTime:(NSString *)aStartTime
               endTime:(NSString *)anEndTime
       appointmentMode:(NSString *)anAppointmentMode;

-(NSString*)timeWindowFormatted;

@end
