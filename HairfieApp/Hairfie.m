//
//  Hairfie.m
//  HairfieApp
//
//  Created by Leo Martin on 08/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "Hairfie.h"
#import "UserRepository.h"
#import "BusinessRepository.h"
#import "AppDelegate.h"

@implementation Hairfie

@synthesize description, hairfieId, businessId, price, picture, user = _user, business = _business;


- (void) setUser:(NSDictionary *) userDic {
    
    UserRepository *userRepository = (UserRepository *)[[AppDelegate lbAdaptater] repositoryWithClass:[UserRepository class]];
    _user = (User *)[userRepository modelWithDictionary:userDic];
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

-(NSString *)hairfieCellUrl {
    return [self pictureUrlwithWidth:@"150" andHeight:@"210"];
}

-(NSString *)hairfieDetailUrl {
    return [self pictureUrlwithWidth:@"320" andHeight:@"355"];
}


@end
