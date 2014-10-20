//
//  ClaimServiceTableViewCell.m
//  HairfieApp
//
//  Created by Leo Martin on 10/20/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "ClaimServiceTableViewCell.h"

@implementation ClaimServiceTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)clearService:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"clearService" object:self];
}

@end
