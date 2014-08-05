//
//  MyButton.h
//  HairfieApp
//
//  Created by Leo Martin on 05/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface MyButton : UIButton
{
    
@private
    NSMutableDictionary *backgroundStates;
@public
    
}

- (void) setBackgroundColor:(UIColor *) _backgroundColor forState:(UIControlState) _state;
- (UIColor*) backgroundColorForState:(UIControlState) _state;

@end