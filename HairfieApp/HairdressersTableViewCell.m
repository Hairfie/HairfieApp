//
//  HairdressersTableViewCell.m
//  HairfieApp
//
//  Created by Leo Martin on 21/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "HairdressersTableViewCell.h"

@implementation HairdressersTableViewCell

- (void)awakeFromNib {
    // Initialization code
    UIImageView *profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    
    profilePicture.layer.cornerRadius = profilePicture.frame.size.height / 2;
    profilePicture.clipsToBounds = YES;
    profilePicture.layer.borderWidth = 1.0f;
    profilePicture.layer.borderColor = [UIColor whiteColor].CGColor;
    profilePicture.image = [UIImage imageNamed:@"leosquare.jpg"];
    [self.viewForBaselineLayout addSubview:profilePicture];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
