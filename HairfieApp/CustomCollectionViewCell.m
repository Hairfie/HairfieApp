//
//  CustomCollectionViewCell.m
//  HairfieApp
//
//  Created by Leo Martin on 08/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "CustomCollectionViewCell.h"

@implementation CustomCollectionViewCell

@synthesize hairfieView = _hairfieView, nbLikes = _nbLikes, name = _name;


- (void)awakeFromNib {
    // Initialization code
    UIImageView *profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(10, 170, 30, 30)];
    profilePicture.image = [UIImage imageNamed:@"leosquare.jpg"];
    
    profilePicture.layer.cornerRadius = profilePicture.frame.size.height / 2;
    profilePicture.clipsToBounds = YES;
    profilePicture.layer.borderWidth = 1.0f;
    profilePicture.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [self.contentView addSubview:profilePicture];
}

@end
