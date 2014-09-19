//
//  NotLoggedAlert.m
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 19/09/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "NotLoggedAlert.h"

@implementation UIViewController(Transitions)

-(void) showNotLoggedAlertWithDelegate:(id)delegate andTitle:(NSString *)title andMessage:(NSString *)message {
    NSString *messageToDisplay = (message == nil) ? @"You need to login or to sign up to do this action" : message;
    NSString *titleToDisplay = (title == nil) ? @"Connected users only" : title;

    id _delegate = ( delegate == nil) ? self : delegate;
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: titleToDisplay
                          message: messageToDisplay
                          delegate:_delegate
                          cancelButtonTitle:nil
                          otherButtonTitles: @"Login / Sign Up",@"Cancel", nil];
    [alert setTag:0];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"backToLogin" object:self];
    } else {
        NSLog(@"Nothing to do");
    }
}

@end
