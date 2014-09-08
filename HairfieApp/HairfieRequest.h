//
//  HairfieRequest.h
//  HairfieApp
//
//  Created by Leo Martin on 08/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LoopBack/LoopBack.h>

@interface HairfieRequest : NSObject

- (void) getHairfies:(LBModelAllSuccessBlock)success
             failure:(SLFailureBlock)failure;


@end
