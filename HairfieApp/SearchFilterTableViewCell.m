//
//  SearchFilterTableViewCell.m
//  HairfieApp
//
//  Created by Leo Martin on 1/19/15.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import "SearchFilterTableViewCell.h"

@implementation SearchFilterTableViewCell


- (void)awakeFromNib {
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setFilterSelected:(BOOL)selected {
    [self.activateBttn setImage:[UIImage imageNamed:@"filter-selected.png"] forState:UIControlStateNormal];
}

-(IBAction)setBttnSelected:(UIButton*)sender {
        
    if (self.isSelected == NO) {
        [self.activateBttn setImage:[UIImage imageNamed:@"filter-selected.png"] forState:UIControlStateNormal];
        self.isSelected = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"filterSelected" object:self];
    }
    
    else {
        [self.activateBttn setImage:[UIImage imageNamed:@"filter-not-selected.png"] forState:UIControlStateNormal];
        self.isSelected = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"filterUnselected" object:self];
    }
}
@end
