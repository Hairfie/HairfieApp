//
//  FacebookPage.h
//  HairfieApp
//
//  Created by Leo Martin on 1/5/15.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LoopBack/LoopBack.h>

@interface FacebookPage : LBModel

@property (strong, nonatomic) NSString *name;


-(id)initWithDictionary:(NSDictionary *)data;
-(id)initWithName:(NSString *)aName;
+(id)fromSetterValue:(id)aValue;

@end
