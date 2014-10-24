//
//  Tag.h
//  HairfieApp
//
//  Created by Antoine Hérault on 22/10/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <LoopBack/LoopBack.h>
#import "TagCategory.h"

@interface Tag : LBModel

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) TagCategory *category;

+(void)getTagsGroupedByCategoryWithSuccess:(void(^)(NSArray *results))aSuccessHandler
                                   failure:(void(^)(NSError *error))aFailureHandler;

@end
