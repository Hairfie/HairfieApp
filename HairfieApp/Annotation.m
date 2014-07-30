//
//  Annotation.m
//  HairfieApp
//
//  Created by Leo Martin on 30/07/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation

@synthesize coordinate;

@synthesize name;

@synthesize time;


-(id)initWithCoordinate:(CLLocationCoordinate2D) c name:(NSString *) n subTitle:(NSString *)timed time:(NSString *)tim

{
    self.coordinate=c;
    
    self.time = tim;
    self.name = n;
    
    return self;
    
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c name:(NSString *)tit

{
    
    self.coordinate=c;
    
    self.name = tit;
    
    return self;
    
}

@end