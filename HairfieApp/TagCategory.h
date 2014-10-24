//
//  TagCategory.h
//  HairfieApp
//
//  Created by Antoine Hérault on 22/10/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <LoopBack/LoopBack.h>

@interface TagCategory : LBModel

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *name;

-(id)initWithDictionary:(NSDictionary *)aDictionary;

+(id)fromSetterValue:(id)aValue;

@end
