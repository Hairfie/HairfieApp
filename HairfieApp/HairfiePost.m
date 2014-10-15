//
//  HairfiePost.m
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 15/10/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "HairfiePost.h"
#import "AppDelegate.h"

@implementation HairfiePost

@synthesize description;

-(id)initWithDictionary:(NSDictionary *)data
{
    return (HairfiePost*)[[Hairfie repository] modelWithDictionary:data];
}

-(id)initWithBusiness:(Business *)aBusiness
{
    self = [super init];
    if (self) {
        self.business = aBusiness;
    }
    return self;
}

-(void)setBusiness:(NSDictionary *)aBusiness
{
    if ([aBusiness isKindOfClass:[Business class]]) {
        _business = (Business *) aBusiness;
    } else if ([aBusiness isEqual:[NSNull null]]) {
        _business = nil;
    } else {
        _business = [[Business alloc] initWithDictionary:aBusiness];
    }
}

-(void)setPictureWithImage:(UIImage *)image andContainer:(NSString *)container {
    _picture = [[Picture alloc] initWithImage:image andContainer:container];
}

-(void)setPrice:(NSDictionary *)aPrice
{
    if ([aPrice isKindOfClass:[Money class]]) {
        _price = (Money *)aPrice;
    } else if ([aPrice isEqual:[NSNull null]]) {
        _price = (Money *)aPrice;
    } else {
        _price = [[Money alloc] initWithDictionary:aPrice];
    }
}

-(void)uploadPictureWithSuccess:(void(^)())aSuccessHandler
             failure:(void(^)(NSError *error))aFailureHandler {
    [self.picture uploadWithSuccess:aSuccessHandler failure:aFailureHandler];
}

-(void)saveWithSuccess:(void(^)())aSuccessHandler
               failure:(void(^)(NSError *error))aFailureHandler
{
    void (^onSuccess)(NSDictionary *) = ^(NSDictionary *result) {
        aSuccessHandler();
    };
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters setObject:[self.picture toApiValue] forKey:@"picture"];
    
    if(self.price != nil) {
        [parameters setObject:self.price.toDictionary forKey:@"price"];
    }
    if(self.description != nil) {
        [parameters setObject:self.description forKey:@"description"];
    }
    if(self.hairdresserName != nil) {
        [parameters setObject:self.hairdresserName forKey:@"hairdresserName"];
    }
    if(self.business != nil) {
        [parameters setObject:self.business.id forKey:@"businessId"];
    }
    
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/hairfies"
                                                                                 verb:@"POST"]
                                        forMethod:@"hairfies.create"];
    LBModelRepository *repository = (LBModelRepository *)[[self class] repository];
    
    [repository invokeStaticMethod:@"create"
                        parameters:parameters
                           success:onSuccess
                           failure:aFailureHandler];
}

-(BOOL)pictureIsUploaded {
    BOOL result = self.picture.name ? YES : NO;
    return result;
}

+(HairfieRepository *)repository
{
    return (HairfieRepository *)[[AppDelegate lbAdaptater] repositoryWithClass:[HairfieRepository class]];
}

@end
