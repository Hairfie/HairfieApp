//
//  Timetable.h
//  HairfieApp
//
//  Created by Antoine Hérault on 19/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Timetable : NSObject

@property (strong, nonatomic) NSArray *monday;
@property (strong, nonatomic) NSArray *tuesday;
@property (strong, nonatomic) NSArray *thursday;
@property (strong, nonatomic) NSArray *wednesday;
@property (strong, nonatomic) NSArray *friday;
@property (strong, nonatomic) NSArray *saturday;
@property (strong, nonatomic) NSArray *sunday;

-(id)initWithDictionary:(NSDictionary *)aDictionary;

-(id)initWithMonday:(NSArray *)aMonday
            tuesday:(NSArray *)aTuesday
           thursday:(NSArray *)aThursday
          wednesday:(NSArray *)aWednesday
             friday:(NSArray *)aFriday
           saturday:(NSArray *)aSaturday
             sunday:(NSArray *)aSunday;

@end
