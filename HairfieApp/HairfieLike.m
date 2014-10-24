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

-(void)setHairfie:(id)aHairfie
{
    _hairfie = [Hairfie fromSetterValue:aHairfie];
}

+(HairfieLikeRepository *)repository
{
    return (HairfieLikeRepository *)[[AppDelegate lbAdaptater] repositoryWithClass:[HairfieLikeRepository class]];
}

@end
