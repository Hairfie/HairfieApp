//
//  ImageSetPickerImageCell.m
//  HairfieApp
//
//  Created by Antoine Hérault on 20/02/2015.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import "ImageSetPickerImageCell.h"

@implementation ImageSetPickerImageCell

-(void)setImage:(UIImage *)image
{
    self.imageView.image = image;
    self.imageView.hidden = image == nil;
    self.addLabel.hidden = image != nil;
}

@end
