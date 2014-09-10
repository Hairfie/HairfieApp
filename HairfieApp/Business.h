//
//  Business.h
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 28/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LoopBack/LoopBack.h>


@interface Business : LBModel

@property (nonatomic) NSString *businessId;
@property (nonatomic) NSString *name;
@property (nonatomic) NSDictionary *address;

-(NSString *)displayAddress;

@end
