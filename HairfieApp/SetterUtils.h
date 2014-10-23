//
//  SetterUtils.h
//  HairfieApp
//
//  Created by Antoine Hérault on 23/10/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SetterUtils : NSObject

+(id)getInstanceOf:(Class)aClass
   fromSetterValue:(id)aValue;

@end
