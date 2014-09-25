//
//  ClaimTimetableCell.m
//  HairfieApp
//
//  Created by Leo Martin on 25/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "ClaimTimetableCell.h"

@implementation ClaimTimetableCell

- (void)awakeFromNib {
    
    _containerView.layer.cornerRadius = 5;
    _containerView.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _containerView.layer.borderWidth = 0.5;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
