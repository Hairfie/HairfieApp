//
//  PostSalonTableViewCell.m
//  HairfieApp
//
//  Created by Leo Martin on 10/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "PostSalonTableViewCell.h"

@implementation PostSalonTableViewCell


- (void)awakeFromNib {
    _salonPicture.layer.cornerRadius = 5;
    _salonPicture.layer.masksToBounds = YES;
}

@end
