//
//  NSString+PhoneFormatter.m
//  HairfieApp
//
//  Created by Leo Martin on 13/10/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "NSString+PhoneFormatter.h"
#import "NBPhoneMetaData.h"
#import "NBPhoneNumber.h"
#import "NBPhoneNumberDesc.h"
#import "NBPhoneNumberUtil.h"
#import "NBNumberFormat.h"

@implementation NSString (PhoneFormatter)


-(NSString*)formatPhoneNumber:(NSString*)phoneNumber
{
    NBPhoneNumberUtil *phoneUtil = [NBPhoneNumberUtil sharedInstance];
    NSError *anError = nil;
    NBPhoneNumber *myNumber = [phoneUtil parse:phoneNumber
                                 defaultRegion:@"FR" error:&anError];
    NSString *formattedPhoneNumber;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    if (anError == nil) {
        // Should check error
        if ([phoneUtil isValidNumber:myNumber] == NO)
        {
            alertView.message = NSLocalizedStringFromTable(@"Phone not valid message", @"Claim", nil);
            alertView.title =  NSLocalizedStringFromTable(@"Phone not valid title", @"Claim", nil);;
            [alertView show];
        }
        else
            formattedPhoneNumber = [phoneUtil format:myNumber
                                    numberFormat:NBEPhoneNumberFormatINTERNATIONAL
                                           error:&anError];
    } else {
        NSLog(@"Error : %@", [anError localizedDescription]);
    }
    
    return formattedPhoneNumber;
}

@end
