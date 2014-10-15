//
//  PictureUploader.h
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 08/09/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LoopBack/LoopBack.h>
#import "Picture.h"

@interface PictureUploader : NSObject

typedef void(^uploadSuccessBlock)(Picture *);

// TODO: move me to Picture.h?
-(void) uploadImage:(UIImage *) image
               toContainer:(NSString *) containerName
                   success:(uploadSuccessBlock) success
                   failure:(SLFailureBlock) failure;


@end
