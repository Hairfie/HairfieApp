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
    if (aBusiness == nil)
        _business = nil;
    else
        _business = [Business fromSetterValue:aBusiness];
}

-(void)setPictureWithImage:(UIImage *)image
              andContainer:(NSString *)container
{
    _picture = [[Picture alloc] initWithImage:image andContainer:container];
    
}

-(void)setPrice:(id)aPrice
{
    _price = [Money fromSetterValue:aPrice];
}

-(void)uploadPictureWithSuccess:(void(^)())aSuccessHandler
                        failure:(void(^)(NSError *error))aFailureHandler
{
    Picture *firstPic = [self.pictures objectAtIndex:0];
    [firstPic uploadWithSuccess:^{
        NSLog(@"Uploaded 1st pic");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"firstPicUploaded" object:self];
        if (self.pictures.count == 2) {
        Picture *secondPic = [self.pictures objectAtIndex:1];
            [secondPic uploadWithSuccess:aSuccessHandler failure:aFailureHandler];
        }
    }failure:aFailureHandler];
}

-(void)saveWithSuccess:(void(^)())aSuccessHandler
               failure:(void(^)(NSError *error))aFailureHandler
{
    // TODO: move hairfie save to Hairfie class
    void (^onSuccess)(NSDictionary *) = ^(NSDictionary *result) {
        Hairfie *hairfie = [[Hairfie alloc] initWithDictionary:result];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:[Hairfie EVENT_SAVED] object:hairfie];
        
        NSLog(@"result :%@", hairfie);
        
        if (self.shareOnFacebook || self.shareOnFacebookPage) {
            [HairfieShare shareHairfie:hairfie.id
                            onFacebook:self.shareOnFacebook
                          facebookPage:self.shareOnFacebookPage
                           withSuccess:^() {
                               aSuccessHandler(hairfie);
                           }
                               failure:^(NSError *error) {
                                   NSLog(@"Failed to share hairfie: %@", error.localizedDescription);
                                   aSuccessHandler(hairfie);
                               }];
        } else {
            aSuccessHandler(hairfie);
        }
    };
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    if (self.pictures != nil) {
        [parameters setObject:Underscore.array(self.pictures).map(^(Picture *p) { return [p toApiValue]; }).unwrap
                       forKey:@"pictures"];
    }
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
    if (self.businessMember != nil) {
        [parameters setObject:self.businessMember.id forKey:@"businessMemberId"];
    }
    if (self.tags != nil) {
        [parameters setObject:Underscore.array(self.tags).map(^(Tag *t) { return [t toApiValue]; }).unwrap
                       forKey:@"tags"];
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
    Picture *firstPic = [self.pictures objectAtIndex:0];
    
    BOOL result = firstPic.name ? YES : NO;
    
    return result;
}

-(Picture *)mainPicture
{
    if (self.pictures.count < 1) {
        return nil;
    }
    
    return [self.pictures objectAtIndex:0];
}

-(BOOL)hasSecondaryPicture
{
    return nil != [self secondaryPicture];
}

-(Picture *)secondaryPicture
{
    if (self.pictures.count < 2) {
        return nil;
    }
    
    return [self.pictures objectAtIndex:1];
}

+(HairfieRepository *)repository
{
    return (HairfieRepository *)[[AppDelegate lbAdaptater] repositoryWithClass:[HairfieRepository class]];
}

@end
