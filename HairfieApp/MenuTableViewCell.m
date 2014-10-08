//
//  MenuTableViewCell.m
//  HairfieApp
//
//  Created by Leo Martin on 29/07/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "MenuTableViewCell.h"

@implementation MenuTableViewCell

@synthesize menuPicto, menuItem;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    float indentPoints = self.indentationLevel * self.indentationWidth;
//    self.contentView.frame = CGRectMake(indentPoints,
//                                        self.contentView.frame.origin.y,self.contentView.frame.size.width - indentPoints,self.contentView.frame.size.height);
//}

@end
