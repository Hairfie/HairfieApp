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

-(void)profileTabStyle
{
    self.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.3].CGColor;
    
    self.layer.borderWidth = 1;
    [self setContentEdgeInsets:UIEdgeInsetsMake(0, 14, 20, 20)];
    self.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-SemiBold" size:18];
}
-(void)profileFollowStyle
{
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 1;
    self.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:16];
    self.layer.cornerRadius = 5.0;
    self.layer.masksToBounds = YES;

}


@end
