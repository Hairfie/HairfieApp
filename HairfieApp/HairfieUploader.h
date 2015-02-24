//
//  HairfieUploader.h
//  HairfieApp
//
//  Created by Leo Martin on 2/24/15.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HairfiePost.h"

@interface HairfieUploader : UIView <UIAlertViewDelegate>

@property (nonatomic) HairfiePost *hairfiePost;

-(void)uploadHairfieImages;
-(void)postHairfie;
-(void)setupHairfieUploader;
-(void)addLoadingOverlay;
-(void)removeLoadingOverlay;
@end
