//
//  UILabel+Style.m
//  HairfieApp
//
//  Created by Leo Martin on 10/22/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "UILabel+Style.h"

@implementation UILabel (Style)


-(void)profileTabStyle
{
    self.textColor = [UIColor whiteColor];
    self.font = [UIFont fontWithName:@"SourceSansPro-Light" size:14];
    self.textAlignment = NSTextAlignmentCenter;
}

-(void)profileUserNameStyle
{
    self.textColor = [UIColor whiteColor];
    self.font = [UIFont fontWithName:@"SourceSansPro-SemiBold" size:18];
    self.textAlignment = NSTextAlignmentCenter;
}

@end
