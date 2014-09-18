//
//  HairfieLike.h
//  HairfieApp
//
//  Created by Antoine Hérault on 18/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <LoopBack/LoopBack.h>
#import "Hairfie.h"

@interface HairfieLike : LBModel

@property (strong, nonatomic) Hairfie *hairfie;
@property (strong, nonatomic) NSDate *createdAt;

-(id)initWithDictionary:(NSDictionary *)data;

@end
