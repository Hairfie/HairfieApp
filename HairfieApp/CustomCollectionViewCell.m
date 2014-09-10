//
//  CustomCollectionViewCell.m
//  HairfieApp
//
//  Created by Leo Martin on 08/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "CustomCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation CustomCollectionViewCell {
    UIImageView *profilePicture;
}

@synthesize hairfieView = _hairfieView, nbLikes = _nbLikes, name = _name, profilePicture = _profilePicture;


- (void)awakeFromNib {

}

-(void)initWithUser:(User *)user {
    _name.text = user.displayName;
    
    _profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(10, 170, 30, 30)];
    [_profilePicture sd_setImageWithURL:[NSURL URLWithString:user.thumbUrl]
                      placeholderImage:[UIColor imageWithColor:[UIColor lightGreyHairfie]]
     ];
    _profilePicture.layer.cornerRadius = _profilePicture.frame.size.height / 2;
    _profilePicture.clipsToBounds = YES;
    _profilePicture.layer.borderWidth = 1.0f;
    _profilePicture.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [self.contentView addSubview:_profilePicture];
}

@end
