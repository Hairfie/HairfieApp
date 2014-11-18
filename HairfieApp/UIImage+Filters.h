//
//  UIImage+Filters.h
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 24/09/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIImage (CustomFilters)

- (UIImage *) toSepia;
- (UIImage *) saturateImage:(float)saturationAmount withContrast:(float)contrastAmount;
- (UIImage *) worn;
- (UIImage *) blendMode:(NSString *)blendMode withImageNamed:(NSString *) imageName;
- (UIImage *) curveFilter;
- (UIImage *) applyLightEffect;
- (UIImage*)vignetteWithRadius:(float)inputRadius andIntensity:(float)inputIntensity;

-(UIImage*)vintageFilter;
- (UIImage *)CIPhotoEffectInstant;
- (UIImage *)CIPhotoEffectTransfer;
- (UIImage *)CIPhotoEffectNoir;
- (UIImage *)CIPhotoEffectProcess;
@end


