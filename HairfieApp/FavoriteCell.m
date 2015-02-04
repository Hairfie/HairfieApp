//
//  FavoriteCell.m
//  HairfieApp
//
//  Created by Leo Martin on 12/9/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "FavoriteCell.h"
#import "Business.h"


#define DEFAULT_PICTURE_URL_BG @"default-user-picture-bg.png"

@implementation FavoriteCell
{
    Business *business;
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
    
    if (businessMember.picture != nil){
        [self setPictureData:businessMember isDefault:NO];
    }
    else if (businessMember.user.picture != nil){
        [self setPictureData:businessMember.user isDefault:NO];
    }
    else {
        [self setPictureData:nil isDefault:YES];
        
    }

}

-(void)setPictureData:(id)entity
            isDefault:(BOOL)isDefault
{
    self.hairdresserPicture.contentMode = UIViewContentModeScaleAspectFill;
    if (isDefault == NO) {
        
        [self.hairdresserPicture sd_setImageWithURL:[entity pictureUrlWithWidth:@100 height:@100]
                                      placeholderImage:[UIColor imageWithColor:[UIColor lightGreyHairfie]]];
        
    }
    else {
        [self.hairdresserPicture setImage:[UIImage imageNamed:DEFAULT_PICTURE_URL_BG]];
        
    }
}
-(IBAction)goToBusiness:(id)sender
{
    NSDictionary *notificationDic = @{@"businessId":self.businessMember.business.id};
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"goToBusiness" object:self userInfo:notificationDic];
}



@end
