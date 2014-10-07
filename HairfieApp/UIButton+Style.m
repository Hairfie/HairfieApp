//
//  UIButton+Style.m
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 02/10/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "UIButton+Style.h"

@implementation UIButton (Style)

-(void)tutoStyle{
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 5.0;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor pinkBtnHairfie];
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    [self setAdjustsImageWhenHighlighted:NO];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.titleLabel setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:self.titleLabel.font.pointSize]];

}

-(void)roundStyle {
    self.layer.cornerRadius = 5.0;
    self.layer.masksToBounds = YES;
}

-(void)noAccountStyle {
    [self roundStyle];
    self.layer.borderWidth = 0.5;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = [[UIColor blackColor] CGColor];
}

-(void)popupStyle {
    [self roundStyle];
    self.backgroundColor = [UIColor pinkHairfie];
}

@end
