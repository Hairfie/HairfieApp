//
//  NSString+PhoneFormatter.h
//  HairfieApp
//
//  Created by Leo Martin on 13/10/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PhoneFormatter)

-(NSString*)formatPhoneNumber:(NSString*)phoneNumber;

-(BOOL)checkPhoneValidity:(NSString*)phoneNumber;

@end
