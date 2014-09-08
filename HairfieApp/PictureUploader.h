//
//  PictureUploader.h
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 08/09/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LoopBack/LoopBack.h>

@interface PictureUploader : NSObject

typedef void(^uploadSucessBlock)(NSString *);

-(void) uploadImage:(UIImage *) image
               toContainer:(NSString *) containerName
                   success:(uploadSucessBlock) success
                   failure:(SLFailureBlock) failure;


@end
