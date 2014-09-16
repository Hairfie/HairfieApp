//
//  User.m
//  HairfieApp
//
//  Created by Leo Martin on 28/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "User.h"
#import "CredentialStore.h"
#import "AppDelegate.h"
#import "MenuViewController.h"

@implementation User

@synthesize userId, userToken, email, firstName, lastName, picture, numHairfies;

-(NSString *)name {
    return [NSString stringWithFormat:@"%@ %@", firstName, lastName];
}

-(NSString *)displayName {
    return [NSString stringWithFormat:@"%@ %@.", firstName, [lastName substringToIndex:1]];
}

-(NSString *)displayHairfies {
    if ([self.numHairfies integerValue] < 2) {
        return [NSString stringWithFormat:@"%@ hairfie", self.numHairfies];
    } else {
        return [NSString stringWithFormat:@"%@ hairfies", self.numHairfies];
    }
}

-(NSString *)pictureUrlwithWidth:(NSString *)width andHeight:(NSString *)height {
    NSString  *url = [[picture objectForKey:@"publicUrl"] stringByAppendingString:@"?"];
    if(width)  url = [NSString stringWithFormat:@"%@&width=%@", url, width];
    if(height) url = [NSString stringWithFormat:@"%@&height=%@", url, height];

    return url;
}

-(NSString *)pictureUrl {
    return [self pictureUrlwithWidth:nil andHeight:nil];
}

-(NSString *)thumbUrl {
    return [self pictureUrlwithWidth:@"100" andHeight:@"100"];
}

-(id)initWithJson:(NSDictionary *)data
{
    return (User *)[[User repository] modelWithDictionary:data];
}

+(void)getById:(NSString *)anId
     success:(void (^)(User *user))aSuccessHandler
     failure:(void (^)(NSError *error))aFailureHandler
{
    [[User repository] findById:anId
                        success:^(LBModel *result) {
                            aSuccessHandler(result);
                        }
                        failure:aFailureHandler];
}

+(LBModelRepository *)repository
{
    return [[AppDelegate lbAdaptater] repositoryWithClass:[UserRepository class]];
}

@end