//
//  CustomCollectionViewCell.m
//  HairfieApp
//
//  Created by Leo Martin on 08/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "CustomCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "User.h"

@implementation CustomCollectionViewCell {
    UIImageView *profilePicture;
}

@synthesize hairfieView = _hairfieView, nbLikes = _nbLikes, name = _name, profilePicture = _profilePicture;


- (void)awakeFromNib
{
    self.hairfieView.contentMode = UIViewContentModeScaleAspectFill;
    self.layer.borderColor = [UIColor colorWithRed:234/255.0f green:236/255.0f blue:238/255.0f alpha:1].CGColor;
    self.layer.borderWidth = 1.0f;
    
    self.profilePicture.layer.cornerRadius = _profilePicture.frame.size.height / 2;
    self.profilePicture.clipsToBounds = YES;
    self.profilePicture.layer.borderWidth = 1.0f;
    self.profilePicture.layer.borderColor = [UIColor whiteColor].CGColor;
}

-(void)setHairfie:(Hairfie *)hairfie
{
    self.name.text = hairfie.user.displayName;
    
    self.nbLikes.text = hairfie.numLikes;
    
    self.profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(10, 170, 30, 30)];
    [self.profilePicture sd_setImageWithURL:[NSURL URLWithString:hairfie.user.thumbUrl]
                           placeholderImage:[UIColor imageWithColor:[UIColor lightGreyHairfie]]];
    
    [self.hairfieView sd_setImageWithURL:[NSURL URLWithString:hairfie.hairfieCellUrl]
                        placeholderImage:[UIColor imageWithColor:[UIColor colorWithRed:234/255.0f
                                                                                 green:236/255.0f
                                                                                  blue:238/255.0f
                                                                                 alpha:1]]];
}

@end
