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

-(void)setClaimSectionPadding
{
    [self.menuPicto setFrame:CGRectMake(32, 12, 20, 20)];
    [self.menuItem setFrame:CGRectMake(72, 0, 320, 44)];

}

@end
