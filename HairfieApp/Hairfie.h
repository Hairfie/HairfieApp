//
//  Hairfie.h
//  HairfieApp
//
//  Created by Leo Martin on 08/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LoopBack/LoopBack.h> 

@interface Hairfie : LBModel

@property (nonatomic) NSString *image;
@property (nonatomic) NSString *imageUrl;
@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *hairfieDesc;
@property (nonatomic) NSString *salonId;
@property (nonatomic) NSDictionary *price;
@property (nonatomic) NSString *hairfieId;


@end
