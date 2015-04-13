//
//  CategoriesCollectionViewCell.h
//  HairfieApp
//
//  Created by Leo Martin on 1/7/15.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchCategory.h"

@interface CategoriesCollectionViewCell : UICollectionViewCell

@property (nonatomic) IBOutlet UIImageView *categoryImage;
@property (nonatomic) IBOutlet UILabel *categoryName;

-(void)setupCellWithName:(NSString*)aName andImage:(UIImage*)anImage;
-(void)setupWithCategory:(SearchCategory*)cat;

@end


