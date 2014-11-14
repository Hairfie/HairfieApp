//
//  Picture.h
//  HairfieApp
//
//  Created by Antoine Hérault on 11/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LoopBack/LoopBack.h>

@interface Picture : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *container;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) UIImage *image;


-(id)initWithDictionary:(NSDictionary *)aDictionary;

-(id)initWithUrl:(NSURL *)anUrl;

-(id)initWithName:(NSString *)aName
        container:(NSString *)aContainer
              url:(NSURL *)anUrl;

-(NSString *)toApiValue;

-(NSURL *)urlWithWidth:(NSNumber *)aWidth
                height:(NSNumber *)anHeight;


- initWithImage:(UIImage *)image andContainer:(NSString *)container;

-(void)uploadWithSuccess:(void(^)())aSuccessHandler
                 failure:(void(^)())aFailureHandler;

+(id)fromSetterValue:(id)aValue;

@end
