//
//  Hairfie.m
//  HairfieApp
//
//  Created by Leo Martin on 08/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "Hairfie.h"

@implementation Hairfie

@synthesize userId, description, hairfieId, salonId, price, picture;


-(NSString *)pictureUrl {
    return [picture objectForKey:@"publicUrl"];
}


@end
