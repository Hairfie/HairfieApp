//
//  constants.h
//  HairfieApp
//
//  Created by Ghislain on 04/08/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#ifndef HairfieApp_constants_h
#define HairfieApp_constants_h

#ifdef DEV
    #define ENV @"dev"
    #define BASE_URL @"https://hairfie.herokuapp.com/"
#elif ADHOC
    #define ENV @"adhoc"
    #define BASE_URL @"http://api.hairfie.com/"
#elif RELEASE
    #define ENV @"release"
    #define BASE_URL @"https://hairfie.herokuapp.com/"
#endif

#define API_URL (BASE_URL @"v1/")
#define API_DATE_FORMAT @"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
#define DISPLAY_DATE_FORMAT @"d MMMM yyyy"

#define TERMS_URL (BASE_URL @"public/mentions_legales_v3_fr.pdf")

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define NEWRELIC_APP_TOKEN @"AA8f75d88dd218aca42fcb24e02ce104e351150d96"
#define GOOGLE_ANALYTICS_TOKEN @"UA-55125713-1"
#define CRASHLYTICS_API_KEY @"dbe02c1fae1a4ced539089c3010f899dfcfc6b18"

#define HAIRFIES_PAGE_SIZE 6

#define KIND_ATHOME @"HOME"
#define KIND_INSALON @"SALON"

#define APPOINTMENT_MODE_REQUIRED @"REQUIRED"
#define APPOINTMENT_MODE_OPTIONAL @"OPTIONAL"
#define APPOINTMENT_MODE_DISABLED @"DISABLED"

#define GENDER_MALE @"MALE"
#define GENDER_FEMALE @"FEMALE"

#define kStatusBarTappedNotification  @"statusBarTappedNotification"

#endif
