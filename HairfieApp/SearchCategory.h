//
//  Category.h
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 13/04/15.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import <LoopBack/LoopBack.h>
#import "Picture.h"

@interface SearchCategory : LBModel

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *position;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) Picture *picture;
@property (strong, nonatomic) NSArray *tags;



-(id)initWithDictionary:(NSDictionary *)aDictionary;

+(void)getCategoryWithSuccess:(void(^)(NSArray *results))aSuccessHandler
                                   failure:(void(^)(NSError *error))aFailureHandler;

+(id)fromSetterValue:(id)aValue;

@end
