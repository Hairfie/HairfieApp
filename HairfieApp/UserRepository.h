//
//  UserRepository.h
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 01/09/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <LoopBack/LoopBack.h>

@interface UserRepository : LBModelRepository

+ (instancetype)repository;

@end
