//
//  PricesTableViewCell.m
//  HairfieApp
//
//  Created by Leo Martin on 21/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "PricesTableViewCell.h"

@implementation PricesTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateWithPrice:(Service *)aPrice
{
    self.itemName.text = aPrice.label;
    self.price.text = aPrice.price.formatted;
}

@end
