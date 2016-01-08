//
//  CustomCollectionViewCell.m
//  HairfieApp
//
//  Created by Leo Martin on 08/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "CustomCollectionViewCell.h"
#import "UIRoundImageView.h"
#import "User.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@implementation CustomCollectionViewCell

@synthesize hairfieView = _hairfieView, nbLikes = _nbLikes, name = _name, profilePicture = _profilePicture;


- (void)awakeFromNib
{
    self.hairfieView.contentMode = UIViewContentModeScaleAspectFill;
    self.layer.borderColor = [UIColor colorWithRed:234/255.0f green:236/255.0f blue:238/255.0f alpha:1].CGColor;
    self.layer.borderWidth = 1.0f;
    self.secondHairfieView.layer.borderWidth = 1;
    self.secondHairfieView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.secondHairfieView.layer.cornerRadius = 2.5;
    self.secondHairfieView.layer.masksToBounds = YES;
}

-(void)setHairfie:(Hairfie *)hairfie
{
    self.profilePicture.layer.borderWidth = 1.0f;
    self.profilePicture.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.profilePicture setBackgroundColor:[UIColor salonDetailTab]];

    
    if (hairfie.displayBusiness == YES) {

        [self.profilePicture sd_setImageWithURL:[hairfie.business.thumbnail urlWithWidth:@100 height:@100]
                               placeholderImage:[UIColor imageWithColor:[UIColor lightGreyHairfie]]];
        
        self.name.text = hairfie.business.name;
    } else if (hairfie.author.picture != nil){
        
        [self.profilePicture sd_setImageWithURL:[hairfie.author pictureUrlWithWidth:
                                                 @100 height:@100]
                               placeholderImage:[UIColor imageWithColor:[UIColor lightGreyHairfie]]];
        self.name.text = hairfie.author.displayName;
    } else {
        [self.profilePicture setImage:[UIImage imageNamed:@"default-user-picture-bg.png"]];
        self.name.text = hairfie.author.displayName;
    }
    
    self.nbLikes.text = hairfie.displayNumLikes;
    self.priceLabel.text = [hairfie displayPrice];
    
    if(hairfie.hasSecondaryPicture) {
        [self.hairfieView setImageWithURL:[hairfie.mainPicture urlWithWidth:@300 height:@420]
                         placeholderImage:[UIColor imageWithColor:[UIColor colorWithRed:234/255.0f green:236/255.0f blue:238/255.0f alpha:1]]
              usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        
        [self.secondHairfieView setImageWithURL:[hairfie.secondaryPicture urlWithWidth:@70 height:@70]
                               placeholderImage:[UIColor imageWithColor:[UIColor colorWithRed:234/255.0f green:236/255.0f blue:238/255.0f alpha:1]]
                    usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        
        self.secondHairfieView.hidden = NO;
    } else {
        [self.hairfieView setImageWithURL:[hairfie.mainPicture urlWithWidth:@300 height:@420]
                         placeholderImage:[UIColor imageWithColor:[UIColor colorWithRed:234/255.0f green:236/255.0f blue:238/255.0f alpha:1]]
              usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        
        self.secondHairfieView.hidden = YES;
    }
    
    if (hairfie.price.amount == nil) {
        self.priceView.hidden = YES;
        self.priceLabel.hidden = YES;
    }
    else {
        self.priceView.hidden = NO;
        self.priceLabel.hidden = NO;
    }
}

-(void)setAsNewHairfieButton {
    self.name.text = NSLocalizedStringFromTable(@"Add a Hairfie", @"Salon_Detail", nil);
    self.nbLikes.hidden = YES;
    self.likes.hidden = YES;
    self.priceView.hidden = YES;
    self.priceLabel.hidden = YES;
    self.secondHairfieView.hidden = YES;
    self.profilePicture = [[UIRoundImageView alloc] initWithFrame:CGRectMake(10, 170, 30, 30)];
    self.profilePicture.layer.borderWidth = 1.0f;
    self.profilePicture.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.profilePicture setBackgroundColor:[UIColor lightGreyHairfie]];
    [self.profilePicture setImage:[UIImage imageNamed:@"add-a-hairfie-profile.png"]];
    [self.hairfieView setImage:[UIImage imageNamed:@"add-a-hairfie.jpg"]];

    [self addSubview:self.profilePicture];
}

@end
