//
//  UserProfileReusableView.m
//  HairfieApp
//
//  Created by Leo Martin on 11/19/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "UserProfileReusableView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"
#import "UIRoundImageView.h"
#import "UIImage+Filters.h"
#import "UIButton+Style.h"
#import "UILabel+Style.h"

@implementation UserProfileReusableView
{
    UIImageView *userProfilePicture;
    BOOL isSetup;
    NSURL *savedUrl;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)setupView {
    
    [self setupData];
    [self setupHeaderPictures];
   

    if (!isSetup) {
        AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        if (![self.user.id isEqualToString:appDelegate.currentUser.id])
            self.editPictureBttn.hidden = YES;
        
        UIView *bottomBorder =  [[UIView alloc] init];
        [bottomBorder setFrame:CGRectMake(0, self.hairfieBttn.frame.size.height, self.hairfieBttn.frame.size.width - 1, 3)];
        bottomBorder.tag = 1;
        bottomBorder.backgroundColor = [UIColor salonDetailTab];
        [self.hairfieBttn addSubview:bottomBorder];
        [self.hairfieBttn setBackgroundColor:[UIColor lightGreyHairfie]];
        isSetup = YES;
        
    }


}

-(void)setupData
{
   
    //[self.nameLabel profileUserNameStyle];
    
    self.nameLabel.text = self.user.name;
    [self.hairfieBttn profileTabStyle];
    [self.hairfieBttn setTitle:[NSString stringWithFormat:@"%@", self.user.numHairfies] forState:UIControlStateNormal];
    
    [self.reviewBttn profileTabStyle];
    [self.reviewBttn setTitle:[NSString stringWithFormat:@"%@", self.user.numBusinessReviews] forState:UIControlStateNormal];
    
    self.reviewLbl.text = NSLocalizedStringFromTable(@"Reviews", @"UserProfile", nil);
   
}


-(void)setupHeaderPictures
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    [manager downloadImageWithURL:[self.user pictureUrlwithWidth:@50 andHeight:@50]
                          options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize)
     {
         // progression tracking code
     }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
     {
         if (image)
         {
             self.backgroundProfilePicture.image = [image applyLightEffect];
         }
     }];
    
    userProfilePicture = [[UIRoundImageView alloc] initWithFrame:CGRectMake(118, 68, 84, 84)];
    userProfilePicture.clipsToBounds = YES;
    userProfilePicture.contentMode = UIViewContentModeScaleAspectFit;
    
    [userProfilePicture sd_setImageWithURL:[self.user pictureUrlwithWidth:@200 andHeight:@200]
                          placeholderImage:[UIColor imageWithColor:[UIColor lightGreyHairfie]]];
    
    UIView *profileBorder =[[UIView alloc] initWithFrame:CGRectMake(113, 63, 94, 94)];
    profileBorder.layer.cornerRadius = profileBorder.frame.size.height / 2;
    profileBorder.clipsToBounds = YES;
    profileBorder.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
    
    [self addSubview:profileBorder];
    [self addSubview:userProfilePicture];
}

-(IBAction)changeTab:(id)sender
{
    [self setButtonSelected:sender];
}

-(void)setButtonSelected:(UIButton*)aButton
{
    UIView *bottomBorder = [[UIView alloc] init];
    
    if (aButton == self.hairfieBttn) {
       
        [aButton setBackgroundColor:[UIColor lightGreyHairfie]];
        [bottomBorder setFrame:CGRectMake(0, aButton.frame.size.height, aButton.frame.size.width - 1, 3)];
        [self.reviewBttn setBackgroundColor:[UIColor clearColor]];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"hairfiesTab" object:self];
        
    }
    if (aButton == self.reviewBttn)
    {
        [aButton setBackgroundColor:[UIColor lightGreyHairfie]];
        [self.hairfieBttn setBackgroundColor:[UIColor clearColor]];
        [bottomBorder setFrame:CGRectMake(1, aButton.frame.size.height, aButton.frame.size.width, 3)];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reviewsTab" object:self];
      
    }
    
    for (UIButton *btn in @[self.hairfieBttn, self.reviewBttn]) {
        
        for (UIView *subView in btn.subviews) {
            
            if (subView.tag == 1) {
                [subView removeFromSuperview];
            }
        }
    }
    
    bottomBorder.backgroundColor = [UIColor salonDetailTab];
    bottomBorder.tag = 1;
    
    [aButton addSubview:bottomBorder];
    
}




@end
