//
//  UIImage+Filters.m
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 24/09/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <Accelerate/Accelerate.h>
#import <float.h>


#import "UIImage+Filters.h"

@implementation UIImage (CustomFilters)


- (UIImage*)toSepia {
    float sepiaAmount = 0.8;
    UIImage *sourceImage = self;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIFilter *filter= [CIFilter filterWithName:@"CISepiaTone"];
    
    CIImage *inputImage = [[CIImage alloc] initWithImage:sourceImage];
    
    [filter setValue:inputImage forKey:@"inputImage"];
    [filter setValue:[NSNumber numberWithFloat:sepiaAmount] forKey:@"inputIntensity"];
    
    return [self imageFromContext:context withFilter:filter];
    
}


- (UIImage*)vignetteWithRadius:(float)inputRadius andIntensity:(float)inputIntensity{
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIFilter *filter= [CIFilter filterWithName:@"CIVignette"];
    
    CIImage *inputImage = [[CIImage alloc] initWithImage:self];
    
    [filter setValue:inputImage forKey:@"inputImage"];
    
    [filter setValue:[NSNumber numberWithFloat:inputIntensity] forKey:@"inputIntensity"];
    [filter setValue:[NSNumber numberWithFloat:inputRadius] forKey:@"inputRadius"];
    
    return [self imageFromContext:context withFilter:filter];
}

- (UIImage*)saturateImage:(float)saturationAmount withContrast:(float)contrastAmount{
    UIImage *sourceImage = self;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIFilter *filter= [CIFilter filterWithName:@"CIColorControls"];
    
    CIImage *inputImage = [[CIImage alloc] initWithImage:sourceImage];
    
    [filter setValue:inputImage forKey:@"inputImage"];
    
    [filter setValue:[NSNumber numberWithFloat:saturationAmount] forKey:@"inputSaturation"];
    [filter setValue:[NSNumber numberWithFloat:contrastAmount] forKey:@"inputContrast"];
    
    
    return [self imageFromContext:context withFilter:filter];
    
}


- (UIImage*)CIPhotoEffectProcess{
    
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIFilter *filter= [CIFilter filterWithName:@"CIPhotoEffectProcess"];
    
    CIImage *inputImage = [[CIImage alloc] initWithImage:self];
    
    [filter setValue:inputImage forKey:@"inputImage"];
    return [self imageFromContext:context withFilter:filter];
}



-(UIImage*)worn{
    CIImage *beginImage = [[CIImage alloc] initWithImage:self];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIWhitePointAdjust"
                                  keysAndValues: kCIInputImageKey, beginImage,
                        @"inputColor",[CIColor colorWithRed:212 green:235 blue:200 alpha:1],
                        nil];
    CIImage *outputImage = [filter outputImage];
    
    CIFilter *filterB = [CIFilter filterWithName:@"CIColorControls"
                                   keysAndValues: kCIInputImageKey, outputImage,
                         @"inputSaturation", [NSNumber numberWithFloat:.8],
                         @"inputContrast", [NSNumber numberWithFloat:0.8],
                         nil];
    CIImage *outputImageB = [filterB outputImage];
    
    CIFilter *filterC = [CIFilter filterWithName:@"CITemperatureAndTint"
                                   keysAndValues: kCIInputImageKey, outputImageB,
                         @"inputNeutral",[CIVector vectorWithX:6500 Y:3000 Z:0],
                         @"inputTargetNeutral",[CIVector vectorWithX:5000 Y:0 Z:0],
                         nil];
    CIImage *outputImageC = [filterC outputImage];
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef imageRef = [context createCGImage:outputImageC fromRect:outputImageC.extent];
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return image;
}


-(UIImage* )blendMode:(NSString *)blendMode withImageNamed:(NSString *) imageName{
    
    /*
     Blend Modes
     
     CISoftLightBlendMode
     CIMultiplyBlendMode
     CISaturationBlendMode
     CIScreenBlendMode
     CIMultiplyCompositing
     CIHardLightBlendMode
     */
    
    CIImage *inputImage = [[CIImage alloc] initWithImage:self];
    
    //try with different textures
    CIImage *bgCIImage = [[CIImage alloc] initWithImage:[UIImage imageNamed:imageName]];
    
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIFilter *filter= [CIFilter filterWithName:blendMode];
    
    // inputBackgroundImage most be the same size as the inputImage
    
    [filter setValue:inputImage forKey:@"inputBackgroundImage"];
    [filter setValue:bgCIImage forKey:@"inputImage"];
    
    return [self imageFromContext:context withFilter:filter];
}

- (UIImage *)CIPhotoEffectTransfer {
    CIImage *inputImage =[[CIImage alloc] initWithImage:self];
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIPhotoEffectTransfer"];
    
    [filter setDefaults];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    
    return [self imageFromContext:context withFilter:filter];
}


- (UIImage *)CIPhotoEffectInstant {
    CIImage *inputImage =[[CIImage alloc] initWithImage:self];
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIPhotoEffectInstant" keysAndValues:kCIInputImageKey, inputImage, nil];
    
    [filter setDefaults];
    
    [filter setValue:inputImage forKey:kCIInputImageKey];
    
    return [self imageFromContext:context withFilter:filter];
}



- (UIImage *)CIPhotoEffectNoir {
    CIImage *inputImage =[[CIImage alloc] initWithImage:self];
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIPhotoEffectNoir" keysAndValues:kCIInputImageKey, inputImage, nil];
    
    [filter setDefaults];
    
    return [self imageFromContext:context withFilter:filter];
}

-(UIImage*)vintageFilter
{
    return [self blendMode:@"CISoftLightBlendMode" withImageNamed:@"paper.jpg"];
}


- (UIImage *)curveFilter {
    
    CIImage *inputImage =[[CIImage alloc] initWithImage:self];
    CIContext *context = [CIContext contextWithOptions:nil];
    CIFilter *filter = [CIFilter filterWithName:@"CIToneCurve"];
    
    [filter setDefaults];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[CIVector vectorWithX:0.0  Y:0.0] forKey:@"inputPoint0"];
    [filter setValue:[CIVector vectorWithX:0.25 Y:0.15] forKey:@"inputPoint1"];
    [filter setValue:[CIVector vectorWithX:0.5  Y:0.5] forKey:@"inputPoint2"];
    [filter setValue:[CIVector vectorWithX:0.75  Y:0.85] forKey:@"inputPoint3"];
    [filter setValue:[CIVector vectorWithX:1.0  Y:1.0] forKey:@"inputPoint4"];
    
    return [self imageFromContext:context withFilter:filter];
}

- (UIImage*)imageFromContext:(CIContext*)context withFilter:(CIFilter*)filter
{
    
    CGImageRef imageRef = [context createCGImage:[filter outputImage] fromRect:filter.outputImage.extent];
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    
    return image;
}

- (UIImage *)applyLightEffect
{
    UIColor *tintColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    
    return [self applyBlurWithRadius:1 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage
{
    // Check pre-conditions.
    if (self.size.width < 1 || self.size.height < 1) {
        NSLog (@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self);
        return nil;
    }
    if (!self.CGImage) {
        NSLog (@"*** error: image must be backed by a CGImage: %@", self);
        return nil;
    }
    if (maskImage && !maskImage.CGImage) {
        NSLog (@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
        return nil;
    }
    
    CGRect imageRect = { CGPointZero, self.size };
    UIImage *effectImage = self;
    
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    if (hasBlur || hasSaturationChange) {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -self.size.height);
        CGContextDrawImage(effectInContext, imageRect, self.CGImage);
        
        vImage_Buffer effectInBuffer;
        effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
        
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
        
        if (hasBlur) {
            // A description of how to compute the box kernel width from the Gaussian
            // radius (aka standard deviation) appears in the SVG spec:
            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
            //
            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
            // successive box-blurs build a piece-wise quadratic convolution kernel, which
            // approximates the Gaussian kernel to within roughly 3%.
            //
            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
            //
            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
            //
            CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
            NSUInteger radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                radius += 1; // force radius to be odd so that the three box-blur methodology works.
            }
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
        }
        BOOL effectImageBuffersAreSwapped = NO;
        if (hasSaturationChange) {
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                0,                    0,                    0,  1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            if (hasBlur) {
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
            }
            else {
                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if (!effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if (effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    // Set up output context.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.size.height);
    
    // Draw base image.
    CGContextDrawImage(outputContext, imageRect, self.CGImage);
    
    // Draw effect image.
    if (hasBlur) {
        CGContextSaveGState(outputContext);
        if (maskImage) {
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
    
    // Add in color tint.
    if (tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    
    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}


@end
