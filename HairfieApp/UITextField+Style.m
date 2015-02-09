//
//  UITextField+Style.m
//  HairfieApp
//
//  Created by Leo Martin on 13/10/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "UITextField+Style.h"

@implementation UITextField (Style)

-(void)textFieldWithPhoneKeyboard:(CGFloat)leftPadding {
    self.keyboardType = UIKeyboardTypePhonePad;
    
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barTintColor = [UIColor colorWithRed:250/255.0f green:66/255.0f blue:67/255.0f alpha:1];
    [keyboardDoneButtonView sizeToFit];
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Validate", @"Claim", nil)
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(validateTextField:)];
    
    
    
    doneButton.tintColor = [UIColor whiteColor];
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = leftPadding;
    
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:fixedSpace,doneButton, nil]];
    self.inputAccessoryView = keyboardDoneButtonView;
}



-(void)validateTextField:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"validateTextField" object:self];
    [self resignFirstResponder];
}


@end
