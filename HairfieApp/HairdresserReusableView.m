//
//  HairdresserReusableView.m
//  HairfieApp
//
//  Created by Leo Martin on 11/25/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "HairdresserReusableView.h"
#import "AppDelegate.h"
#import "UIRoundImageView.h"
#import "UIImage+Filters.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIButton+Style.h"

@implementation HairdresserReusableView
{
    UIImageView *hairdresserPicture;
    BOOL isSetup;
    BOOL isFavorited;
    AppDelegate *appDelegate;
}


-(void)setupView
{
    [self setupData];
    [self setupHeaderPictures];
    
    if (!isSetup) {
        appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        [self getHairdresserFavoriteStatus];
        
        UIView *bottomBorder =  [[UIView alloc] init];
        [bottomBorder setFrame:CGRectMake(0, self.detailsBttn.frame.size.height, self.detailsBttn.frame.size.width, 4)];
        bottomBorder.tag = 1;
        bottomBorder.backgroundColor = [UIColor salonDetailTab];
        [self.detailsBttn addSubview:bottomBorder];
       // [self.detailsBttn setBackgroundColor:[UIColor lightGreyHairfie]];
        isSetup = YES;
        
        [self.favoriteBttn setImage:[UIImage imageNamed:@"picto-fav-hairdresser-selected.png"] forState:UIControlStateSelected];
        [self.favoriteBttn setImage:[UIImage imageNamed:@"picto-fav-hairdresser.png"] forState:UIControlStateNormal];
        self.nameLabel.text = [self.hairdresser displayFullName];
    }
}

-(void)getHairdresserFavoriteStatus
{
    [User isHairdresser:self.hairdresser.id favoritedByUser:appDelegate.currentUser.id success:^(BOOL liked) {
        [self.favoriteBttn setSelected:liked];
        isFavorited = liked;
    }
                failure:^(NSError *error) {
                    NSLog(@"Failed to get favorite status: %@", error.localizedDescription);
                }];
}
-(void)setupHeaderPictures
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    [manager downloadImageWithURL:[self.business.owner pictureUrlwithWidth:@50 andHeight:@50]
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
    
    hairdresserPicture = [[UIRoundImageView alloc] initWithFrame:CGRectMake(118, 68, 84, 84)];
    hairdresserPicture.clipsToBounds = YES;
    hairdresserPicture.contentMode = UIViewContentModeScaleAspectFit;
    
    [hairdresserPicture sd_setImageWithURL:[self.business.owner pictureUrlwithWidth:@200 andHeight:@200]
                          placeholderImage:[UIColor imageWithColor:[UIColor lightGreyHairfie]]];
    
    UIView *profileBorder =[[UIView alloc] initWithFrame:CGRectMake(113, 63, 94, 94)];
    profileBorder.layer.cornerRadius = profileBorder.frame.size.height / 2;
    profileBorder.clipsToBounds = YES;
    profileBorder.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    
    UILabel *proLbl = [[UILabel alloc] initWithFrame:CGRectMake(80, 95, 42, 30)];
    proLbl.text = @"PRO";
    proLbl.textColor = [UIColor whiteColor];
    proLbl.font = [UIFont fontWithName:@"SourceSansPro-Light" size:17];
    proLbl.textAlignment = NSTextAlignmentCenter;
    proLbl.backgroundColor = [UIColor salonDetailTab];
    proLbl.layer.cornerRadius = 2.5;
    proLbl.layer.masksToBounds = YES;
    
    [self addSubview:profileBorder];
    [self addSubview:hairdresserPicture];
    [self addSubview:proLbl];
}

-(void)setupData
{
    [self.hairfieBttn profileTabStyle];
    [self.detailsBttn setTitle:@"Info" forState:UIControlStateNormal];
    [self.hairfieBttn setTitle:[NSString stringWithFormat:@"%zd", self.hairfiesCount] forState:UIControlStateNormal];
}

-(IBAction)changeTab:(id)sender
{
    [self setButtonSelected:sender];
}

-(void)setButtonSelected:(UIButton*)aButton
{
    UIView *bottomBorder = [[UIView alloc] init];
    
    if (aButton == self.detailsBttn) {
        
      //  [aButton setBackgroundColor:[UIColor lightGreyHairfie]];
        [bottomBorder setFrame:CGRectMake(0, aButton.frame.size.height, aButton.frame.size.width, 4)];
        [self.hairfieBttn setBackgroundColor:[UIColor clearColor]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"detailsTab" object:self];
        
    }
    if (aButton == self.hairfieBttn)
    {
        //[aButton setBackgroundColor:[UIColor lightGreyHairfie]];
        [self.detailsBttn setBackgroundColor:[UIColor clearColor]];
        [bottomBorder setFrame:CGRectMake(0, aButton.frame.size.height, aButton.frame.size.width, 4)];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hairfiesTab" object:self];
        
    }
    
    for (UIButton *btn in @[self.hairfieBttn, self.detailsBttn]) {
        
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

-(IBAction)addToFavorite:(id)sender
{
   
    if (isFavorited == NO)
    {
        [self.favoriteBttn setSelected:YES];
        
       // [self.favoriteBttn setImage:[UIImage imageNamed:@"picto-fav-hairdresser-selected.png"] forState:UIControlStateNormal];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addFavorite" object:self];
        isFavorited = YES;
    }
    else
    {
        [self.favoriteBttn setSelected:NO];
     //   [self.favoriteBttn setImage:[UIImage imageNamed:@"picto-fav-hairdresser.png"] forState:UIControlStateNormal];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"removeFavorite" object:self];
        isFavorited = NO;
    }
}

@end
