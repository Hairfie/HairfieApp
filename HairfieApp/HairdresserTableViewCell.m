//
//  HairdresserTableViewCell.m
//  HairfieApp
//
//  Created by Leo Martin on 01/10/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "HairdresserTableViewCell.h"

@implementation HairdresserTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)clearHairdresser:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"clearHairdresser" object:self];
}

@end
