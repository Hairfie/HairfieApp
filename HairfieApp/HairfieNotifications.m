//
//  HairfieNotifications.m
//  HairfieApp
//
//  Created by Leo Martin on 12/3/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "HairfieNotifications.h"

@implementation HairfieNotifications

-(void)showNotificationWithMessage:(NSString*)aMessage ForDuration:(CGFloat)aDuration
{
    
    self.notificationLabelBackgroundColor = [UIColor salonDetailTab];
    self.notificationLabelTextColor = [UIColor whiteColor];
    self.notificationStyle = CWNotificationStyleStatusBarNotification;
    self.notificationAnimationInStyle = CWNotificationAnimationStyleTop;
    self.notificationAnimationOutStyle = CWNotificationAnimationStyleTop;
    
    
    [self displayNotificationWithMessage:aMessage
                             forDuration:aDuration];
    
}




-(void)showNotificationWithMessage:(NSString*)aMessage{
    
    self.notificationLabelBackgroundColor = [UIColor salonDetailTab];
    self.notificationLabelTextColor = [UIColor whiteColor];
    self.notificationStyle = CWNotificationStyleStatusBarNotification;
    self.notificationAnimationInStyle = CWNotificationAnimationStyleTop;
    self.notificationAnimationOutStyle = CWNotificationAnimationStyleTop;
    
    
    [self displayNotificationWithMessage:aMessage completion:nil];
}


-(void)removeNotification {
    [self dismissNotification];
}




@end