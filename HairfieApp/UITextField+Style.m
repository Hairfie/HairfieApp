//
//  UITextField+Style.m
//  HairfieApp
//
//  Created by Leo Martin on 13/10/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "UITextField+Style.h"

@implementation UITextField (Style)

-(void)textFieldWithPhoneKeyboard {
    self.keyboardType = UIKeyboardTypePhonePad;
    
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barTintColor = [UIColor salonDetailTab];
    [keyboardDoneButtonView sizeToFit];
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Validate phone", @"Claim", nil)
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(validateTextField:)];
    
    doneButton.tintColor = [UIColor whiteColor];
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 90;
    
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:fixedSpace,doneButton, nil]];
    self.inputAccessoryView = keyboardDoneButtonView;
}

-(void)validateTextField:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"validateTextField" object:self];
    [self resignFirstResponder];
}


@end
