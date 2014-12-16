//
//  ApplyFiltersViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 09/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "ApplyFiltersViewController.h"
#import "SignUpViewController.h"
#import "CameraOverlayViewController.h"
#import "HairfiePostDetailsViewController.h"
#import "UserProfileViewController.h"
#import "UIImage+Filters.h"
#import "UIButton+Style.h"

@implementation ApplyFiltersViewController
{
    UIImage *original;
    UIImage *original2;
    UIImage *output;
    UIImage *sepia;
    UIImage *curve;
    UIImage *transfer;
    UIImage *instant;
    UIImage *photoEffectNoir;
    UIImage *process;
    UIImage *vignette;
    UIImage *vintage;

    BOOL frontCamera;
}

@synthesize imageView, hairfiePics;


-(void)viewDidLoad
{
    /// FILTERS SCROLL VIEW SIZE
    [_scrollView setContentSize:CGSizeMake(720, 78)];
    ///
      hairfiePics = [[NSMutableArray alloc] init];

    if(self.isHairfie == YES){
        
        
       
        Picture *firstPic = self.hairfiePost.picture;
        original = [self squareCropImage:firstPic.image ToSideLength:320];
      
       
        self.firstImageView.image = original;
        self.firstImageView.layer.cornerRadius = 2;
        self.firstImageView.layer.masksToBounds = YES;
        [hairfiePics addObject:firstPic];
        
        NSLog(@"INIT FILTERS %@", hairfiePics);

    }
    else
        original = [self squareCropImage:self.userPicture ToSideLength:320];
   
    imageView.image = original;
  
    
    self.cancelBttn.layer.cornerRadius = 5;
    self.cancelBttn.layer.masksToBounds = YES;
    
    output = original;
    _nextBttn.layer.cornerRadius = 5;
    NSData *imgData = [[NSData alloc] initWithData:UIImageJPEGRepresentation((original), 0.5)];
    //int imageSize   = imgData.length;
    NSLog(@"size of image in KB: %f ", imgData.length/1024.0);
    _filtersView.hidden = NO;
    [self setupFilters];
    
    UIImage *instantImg = [UIImage imageNamed:@"original.jpeg"];
   
    
    [_instantBttn setImage:[instantImg CIPhotoEffectInstant] forState:UIControlStateNormal];
    
    
    UIImage *img = [UIImage imageNamed:@"original.jpeg"];
    [_transferBttn setImage:[img CIPhotoEffectTransfer] forState:UIControlStateNormal];
    [_processBttn setImage:[img CIPhotoEffectProcess] forState:UIControlStateNormal];
    [_photoEffectNoirBttn setImage:[img CIPhotoEffectNoir] forState:UIControlStateNormal];
    [_vignetteBttn setImage:[img vignetteWithRadius:0 andIntensity:18] forState:UIControlStateNormal];
    [_vintageBttn setImage:[img vintageFilter] forState:UIControlStateNormal];
    
    [_vintageBttn roundStyle];
    [_vignetteBttn roundStyle];
    [_processBttn roundStyle];
    [_photoEffectNoirBttn roundStyle];
    [_sepiaBttn roundStyle];
    [_transferBttn roundStyle];
    [_originalBttn roundStyle];
    [_curveBttn roundStyle];
    [_instantBttn roundStyle];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    if (self.isSecondHairfie == YES)
    {
        Picture *secondPic = self.hairfiePost.picture;
        
       
        original = [self squareCropImage:secondPic.image ToSideLength:320];
        
        self.secondImageView.image = original;
        self.secondImageView.layer.cornerRadius = 2;
        self.secondImageView.layer.masksToBounds = YES;
        imageView.image = original;
        output = original;
        if (hairfiePics.count == 1)
            [hairfiePics addObject:secondPic];
        else {
            [hairfiePics removeObjectAtIndex:1];
            [hairfiePics insertObject:secondPic atIndex:1];
        }
    }
    
    [self setupFilters];

    
}

-(IBAction)goBack:(id)sender
{
    [[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2] viewWillAppear:YES];;
    NSLog(@"nav controllers %@", self.navigationController.viewControllers);
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)addSecondPicture:(id)sender
{
    if (self.isSecondHairfie == NO)
        [self performSegueWithIdentifier:@"addSecondPicture" sender:self];
    else
    {
        Picture *picture = [hairfiePics objectAtIndex:1];
        original = [self squareCropImage:picture.image ToSideLength:320];
        imageView.image = original;
        output = original;
        self.isSecondHairfie = YES;
        self.isHairfie = NO;
        [self setupFilters];
    }
}

-(IBAction)modifyFirstPicture:(id)sender {
    Picture *picture = [hairfiePics objectAtIndex:0];
    original = [self squareCropImage:picture.image ToSideLength:320];
    imageView.image = original;
    output = original;
    self.isHairfie = YES;
    self.isSecondHairfie = NO;
    [self setupFilters];
}

-(void)setupFilters{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sepia = [original toSepia];
        curve = [original curveFilter];
        transfer = [original CIPhotoEffectTransfer];
        instant = [original CIPhotoEffectInstant];
        photoEffectNoir = [original CIPhotoEffectNoir];
        process = [original CIPhotoEffectProcess];
        vignette = [original vignetteWithRadius:0 andIntensity:16];
        vintage = [original vintageFilter];
    });
}



-(IBAction)showMenuActionSheet:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @"Salon_Detail", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles: NSLocalizedStringFromTable(@"Delete", @"Post_Hairfie",nil),nil];
    
    [actionSheet showInView:self.view];
}



-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex) return; // it's the cancel button
    
    else
    {
        [self deletePicture];
    }
}


-(void)deletePicture{
    if (hairfiePics.count == 2)
    {
     
        if (self.isSecondHairfie == YES)
        {
            [hairfiePics removeObjectAtIndex:1];
            [self.secondImageView setImage:[UIImage imageNamed:@"add-second-picture.png"]];
           
        }
        
        if (self.isHairfie == YES)
            
        {
            Picture *picture = [hairfiePics objectAtIndex:1];
            
            [hairfiePics removeAllObjects];
            [hairfiePics addObject:picture];
            [self.firstImageView setImage:picture.image];
            [self.secondImageView setImage:[UIImage imageNamed:@"add-second-picture.png"]];
        }
         [self modifyFirstPicture:self];
    }
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
    if ([segue.identifier isEqualToString:@"addSecondPicture"])
    {
        CameraOverlayViewController *cameraVc = [segue destinationViewController];
        
        cameraVc.isSecondHairfie = YES;
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

-(IBAction)transfer:(id)sender
{
    imageView.image = transfer;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    output = transfer;
}
-(IBAction)curve:(id)sender {
    imageView.image = curve;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    output = curve;
}

-(IBAction)original:(id)sender {
    imageView.image = original;
    output = original;
}
-(IBAction)instant:(id)sender {
    imageView.image = instant;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    output = instant;
}

-(IBAction)process:(id)sender {
    imageView.image = process;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    output = process;
}

-(IBAction)photoEffectNoir:(id)sender {
    imageView.image = photoEffectNoir;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    output = photoEffectNoir;
}

-(IBAction)vignette:(id)sender
{
    imageView.image = vignette;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    output = vignette;
}

- (IBAction)vintage:(id)sender {

    imageView.image = vintage;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    output = vintage;
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
