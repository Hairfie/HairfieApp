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
    [self.categoryImage sd_setImageWithURL:[cat.picture urlWithWidth:@640 height:@54]
                             placeholderImage:[UIColor imageWithColor:[UIColor lightGrey]]];
    if (cat.picture == nil)
        self.backgroundColor = [UIColor lightGrey];
    self.categoryName.text = cat.name;
    self.layer.cornerRadius = 2.5;
    self.layer.masksToBounds = YES;
}


-(void)setupCellWithName:(NSString*)aName andImage:(UIImage*)anImage {
    self.categoryImage.image = anImage;
    if (anImage == nil)
        self.backgroundColor = [UIColor lightGrey];
    self.categoryName.text = aName;
    self.layer.cornerRadius = 2.5;
    self.layer.masksToBounds = YES;
}

@end
