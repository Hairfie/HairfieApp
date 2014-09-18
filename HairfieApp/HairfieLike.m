//
//  HairfieLike.m
//  HairfieApp
//
//  Created by Antoine Hérault on 18/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "HairfieLike.h"
#import "AppDelegate.h"
#import "HairfieLikeRepository.h"


@implementation HairfieLike

-(id)initWithDictionary:(NSDictionary *)data
{
    return (HairfieLike *)[[HairfieLike repository] modelWithDictionary:data];
}

-(void)setHairfie:(NSDictionary *)hairfieDic
{    
    if ([hairfieDic isKindOfClass:[NSNull class]]) return;
    
    _hairfie = [[Hairfie alloc] initWithDictionary:hairfieDic];
}

+(HairfieLikeRepository *)repository
{
    return (HairfieLikeRepository *)[[AppDelegate lbAdaptater] repositoryWithClass:[HairfieLikeRepository class]];
}

@end
