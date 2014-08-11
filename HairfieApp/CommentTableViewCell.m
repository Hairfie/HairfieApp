//
//  CommentTableViewCell.m
//  HairfieApp
//
//  Created by Leo Martin on 11/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell


@synthesize hairfieNb = _hairfieNb, nameLabel = _nameLabel, contentLabel = _contentLabel, statusLabel = _statusLabel, postDate = _postDate;

- (void)awakeFromNib {
    profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(20, 9, 41, 41)];
    
    // mettre viariable photo salon ici
    profilePicture.layer.cornerRadius = profilePicture.frame.size.height / 2;
    profilePicture.clipsToBounds = YES;
    profilePicture.layer.borderWidth = 1.0f;
    profilePicture.layer.borderColor = [UIColor colorWithRed:69/255.0f green:69/255.0f blue:89/255.0f alpha:0.6].CGColor;
    profilePicture.image = [UIImage imageNamed:@"leosquare.jpg"];
    [self.viewForBaselineLayout addSubview:profilePicture];

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
