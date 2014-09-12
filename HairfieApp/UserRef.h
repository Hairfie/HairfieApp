//
//  UserRef.h
//  HairfieApp
//
//  Created by Antoine Hérault on 11/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Picture.h"

@interface UserRef : NSObject

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) Picture  *picture;

@end
