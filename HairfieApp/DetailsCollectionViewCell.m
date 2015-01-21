//
//  DetailsCollectionViewCell.m
//  HairfieApp
//
//  Created by Leo Martin on 11/25/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "DetailsCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation DetailsCollectionViewCell

-(void)setBusiness:(Business *)business
{
    self.workPlaceLbl.text = NSLocalizedStringFromTable(@"work place", @"Hairdresser_Detail", nil);
    self.businessName.text = business.name;
    self.businessAddress.text = [business.address displayCityAndZipCode];
    
    self.businessPicture.layer.cornerRadius = 5;
    self.businessPicture.layer.masksToBounds = YES;
    [self.businessPicture sd_setImageWithURL:[business thumbnailUrlWithWidth:@100 height:@100]
                          placeholderImage:[UIColor imageWithColor:[UIColor lightGreyHairfie]]];
    self.businessPicture.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    self.businessPicture.layer.borderWidth = 0.5;
    self.businessPicture.contentMode = UIViewContentModeScaleAspectFit;
}

@end
