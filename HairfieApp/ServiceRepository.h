//
//  ServiceRepository.h
//  HairfieApp
//
//  Created by Leo Martin on 2/18/15.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LoopBack/LoopBack.h>

@interface ServiceRepository : LBModelRepository

+ (instancetype)repository;

@end
