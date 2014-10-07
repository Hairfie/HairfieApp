//
//  constants.h
//  HairfieApp
//
//  Created by Ghislain on 04/08/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#ifndef HairfieApp_constants_h
#define HairfieApp_constants_h

#define BASE_URL @"http://staging.hairfie.com/" // @"http://localhost:3000/"

#define API_URL (BASE_URL @"api/")
#define API_DATE_FORMAT @"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"

#define TERMS_URL (BASE_URL @"public/mentions_legales_v3_fr.pdf")

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define FB_APP_ID @"726709544031609"
#define FB_SCOPE @[@"email"]

#define NEWRELIC_APP_TOKEN @"AA6b704640532f7dfff195c841b45be17fc7946d63"
#define GOOGLE_ANALYTICS_TOKEN @"UA-55125713-1"
#define CRASHLYTICS_API_KEY @"dbe02c1fae1a4ced539089c3010f899dfcfc6b18"

#define HAIRFIES_PAGE_SIZE 6

#define KIND_ATHOME @"HOME"
#define KIND_INSALON @"SALON"

#define APPOINTMENT_MODE_REQUIRED = @"REQUIRED"
#define APPOINTMENT_MODE_OPTIONAL = @"OPTIONAL"
#define APPOINTMENT_MODE_DISABLED = @"DISABLED"

#endif
