//
//  HairfieShare.h
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 24/10/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <LoopBack/LoopBack.h>
#import "Hairfie.h"

@interface HairfieShare : LBModel

+(void)shareHairfie:(NSString *)hairfieId
         onFacebook:(BOOL)facebook
       facebookPage:(BOOL)facebookPage
        withSuccess:(void(^)())aSuccessHandler
            failure:(void(^)(NSError *error))aFailureHandler;
                        
@end
