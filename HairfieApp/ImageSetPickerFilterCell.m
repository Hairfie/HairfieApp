//
//  ImageSetPickerFilterCell.m
//  HairfieApp
//
//  Created by Antoine Hérault on 20/02/2015.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import "ImageSetPickerFilterCell.h"

@implementation ImageSetPickerFilterCell

-(void)setFilter:(NSString *)filter
{
    self.image.image = [UIImage imageNamed:[NSString stringWithFormat:@"filter-%@.jpg", filter]];
}

@end
