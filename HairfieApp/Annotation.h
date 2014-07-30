//
//  Annotation.h
//  HairfieApp
//
//  Created by Leo Martin on 30/07/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface Annotation : NSObject <MKAnnotation>

{
    
    CLLocationCoordinate2D coordinate;
    
    NSString *title;
    
    NSString *time;
    
}

@property (nonatomic)CLLocationCoordinate2D coordinate;

@property (nonatomic, retain) NSString *name;

@property (nonatomic,retain) NSString *time;

-(id)initWithCoordinate:(CLLocationCoordinate2D) c name:(NSString *) n subTitle:(NSString *)timed time:(NSString *)tim;

-(id)initWithCoordinate:(CLLocationCoordinate2D) c name:(NSString *) n;

@end
