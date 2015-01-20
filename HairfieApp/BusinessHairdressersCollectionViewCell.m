//
//  BusinessHairdressersCollectionViewCell.m
//  HairfieApp
//
//  Created by Leo Martin on 11/24/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "BusinessHairdressersCollectionViewCell.h"

@implementation BusinessHairdressersCollectionViewCell

-(void)setBusinessMember:(BusinessMember *)businessMember
{
    [self.hairdresserName setText:[businessMember displayFullName]];
}

@end
