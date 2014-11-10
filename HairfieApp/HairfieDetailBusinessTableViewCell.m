//
//  HairfieDetailBusinessTableViewCell.m
//  HairfieApp
//
//  Created by Antoine Hérault on 05/11/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "HairfieDetailBusinessTableViewCell.h"

@implementation HairfieDetailBusinessTableViewCell

-(void)awakeFromNib
{
    self.bookButton.layer.cornerRadius = 3;
    [self.bookButton setTitle:NSLocalizedStringFromTable(@"Book", @"Hairfie_Detail", nil) forState:UIControlStateNormal];
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setBusiness:(Business *)aBusiness
{
    _business = aBusiness;
    
    self.nameLabel.text = self.business.name;
    self.streetAddressLabel.text = self.business.address.street;
    self.cityLabel.text = self.business.address.displayCityAndZipCode;

    if (nil == self.business.phoneNumber) {
        self.bookButton.hidden = YES;
        self.bookButton.userInteractionEnabled = NO;
    } else {
        self.bookButton.hidden = NO;
        self.bookButton.userInteractionEnabled = YES;
    }
}

-(IBAction)book:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", self.business.phoneNumber]]];
}

@end
