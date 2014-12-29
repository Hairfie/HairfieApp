//
//  HairfieNotifications.h
//  HairfieApp
//
//  Created by Leo Martin on 12/3/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "CWStatusBarNotification.h"

@interface HairfieNotifications : CWStatusBarNotification


-(void)showNotificationWithMessage:(NSString*)aMessage ForDuration:(CGFloat)aDuration;
-(void)showNotificationWithMessage:(NSString*)aMessage;
-(void)removeNotification;

@end