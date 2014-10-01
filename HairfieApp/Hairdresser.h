//
//  Hairdresser.h
//  HairfieApp
//
//  Created by Leo Martin on 01/10/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Hairdresser : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *phoneNumber;


-(NSDictionary*)toDictionary;
-(NSString*)displayFullName;
-(id)initWithDictionary:(NSDictionary *)aDictionary;
-(id)initWithFirstName:(NSString*)aFirstName
              lastName:(NSString*)aLastName
                 email:(NSString*)anEmail
           phoneNumber:(NSString*)aPhoneNumber;
@end
