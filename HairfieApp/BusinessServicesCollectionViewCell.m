//
//  BusinessServicesCollectionViewCell.m
//  HairfieApp
//
//  Created by Leo Martin on 11/24/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "BusinessServicesCollectionViewCell.h"

@implementation BusinessServicesCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setService:(Service*)service
{
    [self.serviceName setText:service.label];
    [self.servicePrice setText:[service.price formatted]];
}

@end
