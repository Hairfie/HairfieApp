//
//  ImageSetPickerFilterCell.h
//  HairfieApp
//
//  Created by Antoine Hérault on 20/02/2015.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageSetPickerFilterCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIImageView *image;

@property (nonatomic) NSString *filter;

@end
