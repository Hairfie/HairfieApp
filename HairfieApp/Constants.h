//
//  constants.h
//  HairfieApp
//
//  Created by Ghislain on 04/08/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#ifndef HairfieApp_constants_h
#define HairfieApp_constants_h

#define BASE_URL @"http://api.staging.hairfie.com/" // @"http://localhost:3000/"

#define API_URL (BASE_URL @"api/")


#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define FB_APP_ID @"726709544031609"
#define FB_SCOPE @[@"email"]

#define HAIRFIES_PAGE_SIZE 6

#endif
