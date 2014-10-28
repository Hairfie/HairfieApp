//
//  Day.h
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 28/10/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Day : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *selectorName;
@property (nonatomic) NSNumber *dayInt;


-(id)initWithName:(NSString *)aName andSelectorName:(NSString *)aSelector andInt:(NSNumber*)aDayInt;
-(SEL)selector;

@end
