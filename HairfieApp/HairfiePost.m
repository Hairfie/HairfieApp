//
//  HairfiePost.m
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 15/10/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "HairfiePost.h"
#import "AppDelegate.h"
#import "Tag.h"

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

-(void)setBusiness:(id)aBusiness
{
    _business = [Business fromSetterValue:aBusiness];
}

-(void)setPictureWithImage:(UIImage *)image
              andContainer:(NSString *)container
{
    _picture = [[Picture alloc] initWithImage:image andContainer:container];
    
    if (self.pictures.count == 0)
        self.pictures = [[NSMutableArray alloc] init];
    [self.pictures addObject:_picture];
    
}

-(void)setPrice:(id)aPrice
{
    _price = [Money fromSetterValue:aPrice];
}

-(void)uploadPictureWithSuccess:(void(^)())aSuccessHandler
             failure:(void(^)(NSError *error))aFailureHandler {
    [self.picture uploadWithSuccess:aSuccessHandler failure:aFailureHandler];
}

-(void)saveWithSuccess:(void(^)())aSuccessHandler
               failure:(void(^)(NSError *error))aFailureHandler
{
    // TODO: move hairfie save to Hairfie class
    void (^onSuccess)(NSDictionary *) = ^(NSDictionary *result) {
        Hairfie *hairfie = [[Hairfie alloc] initWithDictionary:result];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:[Hairfie EVENT_SAVED] object:hairfie];
        
        NSLog(@"result :%@", hairfie);
        if(self.shareOnFB) {
            Hairfie *newHairfie = [[Hairfie alloc] initWithDictionary:result];
            [HairfieShare shareHairfie:newHairfie.id success:^{
                aSuccessHandler(hairfie);
            } failure:^(NSError *error) {
                NSLog(@"Error : %@", error.description);
                aSuccessHandler(hairfie);
            }];
        } else {
            aSuccessHandler(hairfie);
        }
    };
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters setObject:[self.picture toApiValue] forKey:@"picture"];
    
    if(self.price != nil) {
        [parameters setObject:self.price.toDictionary forKey:@"price"];
    }
    if(self.description != nil) {
        [parameters setObject:self.description forKey:@"description"];
    }
  
    if(self.business != nil) {
        [parameters setObject:self.business.id forKey:@"businessId"];
    }
    if(self.selfMade == YES) {
        [parameters setObject:@true forKey:@"selfMade"];
    }
    if(self.customerEmail != nil) {
        [parameters setObject:self.customerEmail forKey:@"customerEmail"];
    }
    if (self.hairdresser != nil)
    {
        [parameters setObject:self.hairdresser.id forKey:@"hairdresserId"];
    }

    if (self.tags != nil) {
        NSMutableArray *tagsToSend = [[NSMutableArray alloc] init];
        for (Tag *tag in self.tags) {
            [tagsToSend addObject:[tag toApiValue]];
        }
        [parameters setObject:tagsToSend forKey:@"tags"];
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

-(BOOL)pictureIsUploaded
{
    BOOL result = self.picture.name ? YES : NO;
    return result;
}

+(HairfieRepository *)repository
{
    return (HairfieRepository *)[[AppDelegate lbAdaptater] repositoryWithClass:[HairfieRepository class]];
}

@end
