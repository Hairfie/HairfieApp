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

#define DEFAULT_PICTURE_URL @"default-user-picture.png"
#define DEFAULT_PICTURE_URL_BG @"default-user-picture-bg.png"

@implementation UserProfileReusableView
{
    UIImageView *userProfilePicture;
    BOOL isSetup;
    NSURL *savedUrl;
}

-(void)setupView {
    
    [self setupData];
    
   

    if (!isSetup) {
        AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        if (![self.user.id isEqualToString:appDelegate.currentUser.id])
            self.editPictureBttn.hidden = YES;
        
        UIView *bottomBorder =  [[UIView alloc] init];
        
        [bottomBorder setFrame:CGRectMake(0, self.hairfieBttn.frame.size.height, self.viewForBaselineLayout.frame.size.width / 2, 3)];
        bottomBorder.tag = 1;
        bottomBorder.backgroundColor = [UIColor salonDetailTab];
        [self.hairfieBttn addSubview:bottomBorder];
        [self.hairfieBttn setBackgroundColor:[UIColor lightBlackTab]];
        isSetup = YES;
        [self setupHeaderPictures];
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
    userProfilePicture = [[UIRoundImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2 - 75, 45, 150, 150)];
    userProfilePicture.clipsToBounds = YES;
    userProfilePicture.contentMode = UIViewContentModeScaleAspectFit;

    if (self.user.picture != nil) {
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    [manager downloadImageWithURL:[self.user pictureUrlWithWidth:@50 height:@50]
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
    
       
    [userProfilePicture sd_setImageWithURL:[self.user pictureUrlWithWidth:@150 height:@150]
                          placeholderImage:[UIColor imageWithColor:[UIColor lightGreyHairfie]]];
    
    } else {
        
        self.backgroundProfilePicture.image = [[UIImage imageNamed:DEFAULT_PICTURE_URL_BG] applyLightEffect];
        [userProfilePicture setImage:[UIImage imageNamed:DEFAULT_PICTURE_URL]];
    }
    
    UIView *profileBorder =[[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2 - 80, 40, 160, 160)];
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
       
        [aButton setBackgroundColor:[UIColor lightBlackTab]];
        [bottomBorder setFrame:CGRectMake(0, aButton.frame.size.height, aButton.frame.size.width, 3)];
        [self.reviewBttn setBackgroundColor:[UIColor clearColor]];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"hairfiesTab" object:self];
        
    }
    if (aButton == self.reviewBttn)
    {
        [aButton setBackgroundColor:[UIColor lightBlackTab]];
        [self.hairfieBttn setBackgroundColor:[UIColor clearColor]];
        [bottomBorder setFrame:CGRectMake(0, aButton.frame.size.height, aButton.frame.size.width, 3)];
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
