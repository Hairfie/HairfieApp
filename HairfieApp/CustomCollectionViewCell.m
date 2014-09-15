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

@implementation CustomCollectionViewCell

@synthesize hairfieView = _hairfieView, nbLikes = _nbLikes, name = _name, profilePicture = _profilePicture;


- (void)awakeFromNib
{
    self.hairfieView.contentMode = UIViewContentModeScaleAspectFill;
    self.layer.borderColor = [UIColor colorWithRed:234/255.0f green:236/255.0f blue:238/255.0f alpha:1].CGColor;
    self.layer.borderWidth = 1.0f;
}

-(void)setHairfie:(Hairfie *)hairfie
{
    self.name.text = hairfie.author.displayName;

    self.nbLikes.text = hairfie.numLikes;

    self.profilePicture = [[UIRoundImageView alloc] initWithFrame:CGRectMake(10, 170, 30, 30)];
    self.profilePicture.layer.borderWidth = 1.0f;
    self.profilePicture.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.profilePicture sd_setImageWithURL:[NSURL URLWithString:hairfie.author.thumbUrl]
                           placeholderImage:[UIColor imageWithColor:[UIColor lightGreyHairfie]]];

    [self.hairfieView sd_setImageWithURL:[NSURL URLWithString:hairfie.hairfieCellUrl]
                        placeholderImage:[UIColor imageWithColor:[UIColor colorWithRed:234/255.0f
                                                                                 green:236/255.0f
                                                                                  blue:238/255.0f
                                                                                 alpha:1]]];

    [self addSubview:self.profilePicture];
}

@end
