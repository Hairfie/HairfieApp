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
    if(numHairfies) {
        return  [NSString stringWithFormat:@"%@ hairfies", numHairfies];;
    } else {
        return  @"0 hairfies";
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

+(LBModelRepository *)repository
{
    return [[AppDelegate lbAdaptater] repositoryWithClass:[UserRepository class]];
}

@end