//
//  CALayer+XibConfiguration.m
//  HairfieApp
//
//  Created by Antoine Hérault on 14/11/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "CALayer+XibConfiguration.h"

@implementation CALayer(XibConfiguration)

-(void)setBorderUIColor:(UIColor*)color
{
    self.borderColor = color.CGColor;
}

-(UIColor*)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
