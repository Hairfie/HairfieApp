//
//  Picture.h
//  HairfieApp
//
//  Created by Antoine Hérault on 11/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Picture : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *container;
@property (strong, nonatomic) NSString *url;

-(id)initWithDictionary:(NSDictionary *)aDictionary;

-(id)initWithUrl:(NSString *)anUrl;

-(id)initWithName:(NSString *)aName
        container:(NSString *)aContainer
              url:(NSString *)anUrl;

-(NSString *)toApiValue;

-(NSString *)urlWithWidth:(NSNumber *)aWidth
                   height:(NSNumber *)anHeight;

@end
