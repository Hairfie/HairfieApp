//
//  UIImage+Filters.m
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 24/09/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "UIImage+Filters.h"
#import <UIKit/UIKit.h>

@interface UIImage (CustomFilters)
- (UIImage *) toSepia:(float)sepiaAmount;
- (UIImage *) saturateImage:(float)saturationAmount withContrast:(float)contrastAmount;
- (UIImage *) vignetteWithRadius:(float)inputRadius andIntensity:(float)inputIntensity;
- (UIImage *) worn;
- (UIImage *) blendMode:(NSString *)blendMode withImageNamed:(NSString *) imageName;
- (UIImage *) curveFilter;
@end