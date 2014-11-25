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
    self.serviceName.hidden = NO;
    self.servicePrice.hidden = NO;
    self.noServiceLabel.hidden = YES;
}

-(void)initWithoutData
{
    self.serviceName.hidden = YES;
    self.servicePrice.hidden = YES;
    self.noServiceLabel.text = NSLocalizedStringFromTable(@"No service", @"Salon_Detail", nil);
    self.noServiceLabel.hidden = NO;
}

@end
