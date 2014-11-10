//
//  ApplyFiltersViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 09/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "ApplyFiltersViewController.h"
#import "SignUpViewController.h"
#import "HairfiePostDetailsViewController.h"
#import "UserProfileViewController.h"
#import "UIImage+Filters.h"
#import "UIButton+Style.h"

@implementation ApplyFiltersViewController
{
    UIImage *original;
    UIImage *output;
    UIImage *sepia;
    UIImage *newFilter;
    BOOL frontCamera;
}

@synthesize imageView;


-(void)viewDidLoad
{
    
    if(self.isHairfie == YES)
        original = [self squareCropImage:self.hairfiePost.picture.image ToSideLength:320];
    else
        original = [self squareCropImage:self.userPicture ToSideLength:320];
    imageView.image = original;
  
    output = original;
    _nextBttn.layer.cornerRadius = 5;
    NSData *imgData = [[NSData alloc] initWithData:UIImageJPEGRepresentation((original), 0.5)];
    //int imageSize   = imgData.length;
    NSLog(@"size of image in KB: %f ", imgData.length/1024.0);
    _filtersView.hidden = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sepia = [original toSepia];
        newFilter = [original curveFilter];
    });
    
    [_sepiaBttn roundStyle];
    [_originalBttn roundStyle];
    [_curveBttn roundStyle];
    
}

-(IBAction)goBack:(id)sender
{
    [[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2] viewWillAppear:YES];;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"setupHairfie"])
    {
        HairfiePostDetailsViewController *details = [segue destinationViewController];
        [_hairfiePost setPictureWithImage:output andContainer:@"hairfies"];
        [details setHairfiePost:_hairfiePost];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImageWriteToSavedPhotosAlbum(output, nil, nil, nil);
        });
    }
    if ([segue.identifier isEqualToString:@"backToSignUp"]){
        SignUpViewController *signUp = [segue destinationViewController];
        
    
        [signUp setImageFromSegue:output];
        NSLog(@"image %@", signUp.imageFromSegue);
       // signUp.imageFromSegue = output;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImageWriteToSavedPhotosAlbum(output, nil, nil, nil);
        });
    }
   if ([segue.identifier isEqualToString:@"saveUserPicture"])
    {
        UserProfileViewController *userProfile = [segue destinationViewController];
        
        userProfile.imageFromSegue = output;
        userProfile.user = self.user;
        userProfile.isCurrentUser = YES;
    }
}



- (UIImage *)squareCropImage:(UIImage *)sourceImage ToSideLength:(CGFloat)sideLength
{
    // input size comes from image
    CGSize inputSize = sourceImage.size;
    
    // round up side length to avoid fractional output size
    sideLength = ceilf(sideLength);
    
    // output size has sideLength for both dimensions
    CGSize outputSize = CGSizeMake(sideLength, sideLength);
    
    // calculate scale so that smaller dimension fits sideLength
    CGFloat scale = MAX(sideLength / inputSize.width,
                        sideLength / inputSize.height);
    
    // scaling the image with this scale results in this output size
    CGSize scaledInputSize = CGSizeMake(inputSize.width * scale,
                                        inputSize.height * scale);
    
    // determine point in center of "canvas"
    CGPoint center = CGPointMake(outputSize.width/2.0,
                                 outputSize.height/2.0);
    
    // calculate drawing rect relative to output Size
    CGRect outputRect = CGRectMake(center.x - scaledInputSize.width/2.0,
                                   center.y - scaledInputSize.height/2.0,
                                   scaledInputSize.width,
                                   scaledInputSize.height);
    
    // begin a new bitmap context, scale 0 takes display scale
    UIGraphicsBeginImageContextWithOptions(outputSize, YES, 0);
    
    // optional: set the interpolation quality.
    // For this you need to grab the underlying CGContext
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(ctx, kCGInterpolationHigh);
    
    // draw the source image into the calculated rect
    [sourceImage drawInRect:outputRect];
    
    // create new image from bitmap context
    UIImage *outImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // clean up
    UIGraphicsEndImageContext();
    
    // pass back new image
    return outImage;
}

-(IBAction)sepia:(id)sender {
    imageView.image = sepia;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    output = sepia;
}

-(IBAction)newFilter:(id)sender {
    imageView.image = newFilter;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    output = newFilter;
}

-(IBAction)original:(id)sender {
    imageView.image = original;
    output = original;
}

-(IBAction)backToSignUp:(id)sender
{
    [self performSegueWithIdentifier:@"backToSignUp" sender:self];
}

-(IBAction)validatePic:(id)sender
{
    if (self.isProfile == YES) {
        [self performSegueWithIdentifier:@"saveUserPicture" sender:self];
       // [[NSNotificationCenter defaultCenter] postNotificationName:@"currentUser" object:self];
    }
    else
    [self performSegueWithIdentifier:@"setupHairfie" sender:self];
}

@end
