//
//  User.h
//  HairfieApp
//
//  Created by Leo Martin on 28/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LoopBack/LoopBack.h>


@interface User : LBModel

@property (nonatomic) NSString *userToken;
@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *gender;
@property (nonatomic) NSString *picture;
@property (nonatomic) NSString *email;

-(NSString *)name;


@end
