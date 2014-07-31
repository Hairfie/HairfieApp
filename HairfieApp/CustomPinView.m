//
//  CustomPinView.m
//  HairfieApp
//
//  Created by Leo Martin on 31/07/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "CustomPinView.h"

@implementation CustomPinView
@synthesize myTitle = _myTitle;

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _myTitle = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:16.0];
            label.translatesAutoresizingMaskIntoConstraints = NO;
            label;
        });
        [self addSubview:_myTitle];
    
        self.layer.anchorPoint = CGPointMake(0.5, 1.0);
        self.layer.backgroundColor = [UIColor whiteColor].CGColor;
        self.layer.borderColor = [UIColor colorWithRed:0.890 green:0.875 blue:0.843 alpha:1.000].CGColor;
        self.layer.borderWidth = 0.5;
        self.layer.cornerRadius = 8.0;
        self.layer.masksToBounds = YES;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
