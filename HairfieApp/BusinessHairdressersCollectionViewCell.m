//
//  BusinessHairdressersCollectionViewCell.m
//  HairfieApp
//
//  Created by Leo Martin on 11/24/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "BusinessHairdressersCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


#define DEFAULT_PICTURE_URL_BG @"default-user-picture-bg.png"

@implementation BusinessHairdressersCollectionViewCell

-(void)setBusinessMember:(BusinessMember *)businessMember
{
    
     UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 0)];
    self.businessMemberName.leftView = paddingView;
    self.businessMemberName.leftViewMode = UITextFieldViewModeAlways;
    [self.businessMemberName setText:[businessMember displayFullName]];
 
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
    self.businessMemberPicture.contentMode = UIViewContentModeScaleAspectFill;
    if (isDefault == NO) {
        
        [self.businessMemberPicture sd_setImageWithURL:[entity pictureUrlWithWidth:@60 height:@60]
                                 placeholderImage:[UIColor imageWithColor:[UIColor lightGreyHairfie]]];
        
    }
    else {
        [self.businessMemberPicture setImage:[UIImage imageNamed:DEFAULT_PICTURE_URL_BG]];
        
    }
}


@end
