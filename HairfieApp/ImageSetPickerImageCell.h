//
//  ImageSetPickerImageCell.h
//  HairfieApp
//
//  Created by Antoine Hérault on 20/02/2015.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageSetPickerImageCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *addLabel;

@property (nonatomic, strong) UIImage *image;

@end
