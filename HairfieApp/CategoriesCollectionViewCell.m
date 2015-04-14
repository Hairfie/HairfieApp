//
//  CategoriesCollectionViewCell.m
//  HairfieApp
//
//  Created by Leo Martin on 1/7/15.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import "CategoriesCollectionViewCell.h"

@implementation CategoriesCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setupWithCategory:(SearchCategory*)cat {
    [self.categoryImage sd_setImageWithURL:cat.picture.url
                             placeholderImage:[UIColor imageWithColor:[UIColor lightGrey]]];
    if (cat.picture == nil)
        self.backgroundColor = [UIColor lightGrey];
    self.categoryName.text = cat.name;
    self.layer.cornerRadius = 2.5;
    self.layer.masksToBounds = YES;
}


@end
