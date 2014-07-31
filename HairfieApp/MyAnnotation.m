//
//  Annotation.m
//  HairfieApp
//
//  Created by Leo Martin on 30/07/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation

@synthesize coordinate;

@synthesize title;


-(id)initWithCoordinate:(CLLocationCoordinate2D) c title:(NSString *)t

{
    self.coordinate=c;
    self.title = t;
    return self;
}




@end