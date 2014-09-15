//
//  UIRoundImageView.m
//  HairfieApp
//
//  Created by Antoine Hérault on 15/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "UIRoundImageView.h"

@implementation UIRoundImageView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = self.frame.size.height / 2;
        self.clipsToBounds = YES;
    }
    return self;
}

@end
