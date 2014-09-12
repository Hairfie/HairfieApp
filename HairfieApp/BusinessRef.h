//
//  BusinessRef.h
//  HairfieApp
//
//  Created by Antoine Hérault on 11/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Address.h"

@interface BusinessRef : NSObject

@property (strong, nonatomic) NSString* id;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) Address* address;

-(id)initWithId:(NSString *)anId name:(NSString *)aName address:(Address *)anAddress;

@end
