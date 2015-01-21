//
//  FavoriteCell.m
//  HairfieApp
//
//  Created by Leo Martin on 12/9/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "FavoriteCell.h"
#import "Business.h"

@implementation FavoriteCell
{
    Business *business;
    UIImageView *businessMemberPicture;
}

-(void)setBusinessMember:(BusinessMember *)businessMember
{
    _businessMember = businessMember;
    
    [self.hairdresserName setTitle:businessMember.displayFullName forState:UIControlStateNormal];
    [self.hairdresserBusiness setTitle:businessMember.business.name forState:UIControlStateNormal];
    
    self.hairdresserBusiness.layer.cornerRadius = 5;
    self.hairdresserBusiness.layer.masksToBounds = YES;
    
    CGSize textSize = [[self.hairdresserBusiness.titleLabel text] sizeWithAttributes:@{NSFontAttributeName:[self.hairdresserBusiness.titleLabel font]}];
    
    self.businessWidth.constant = textSize.width + 20;
    
    [self.hairdresserHairfies setText:[NSString stringWithFormat:@"%@ hairfies", businessMember.numHairfies]];
}

-(IBAction)goToBusiness:(id)sender
{
    NSDictionary *notificationDic = @{@"businessId":self.businessMember.business.id};
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"goToBusiness" object:self userInfo:notificationDic];
}

@end
