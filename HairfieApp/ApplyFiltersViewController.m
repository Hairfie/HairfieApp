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
    NSMutableDictionary *filteredHairfies;
    BOOL frontCamera;
}

@synthesize imageView, hairfiePics;


-(void)viewDidLoad
{
    /// FILTERS SCROLL VIEW SIZE
    [_scrollView setContentSize:CGSizeMake(720, 78)];
    ///
    hairfiePics = [[NSMutableArray alloc] init];
    filteredHairfies = [[NSMutableDictionary alloc] init];

    [self.firstImageView setContentMode:UIViewContentModeScaleAspectFill];
    self.firstImageView.layer.cornerRadius = 2;
    self.firstImageView.layer.masksToBounds = YES;
    
    if (self.isHairfie == YES){
        Picture *firstPic = self.hairfiePost.picture;
        original = [self squareCropImage:firstPic.image ToSideLength:320];
        firstPic.image = original;
        
        
    
        [hairfiePics addObject:firstPic];
    }
    
    if (self.isProfile == YES) {
        original = [self squareCropImage:self.hairfiePost.picture.image ToSideLength:320];
    
        self.secondImgBttn.hidden = YES;
        self.secondImageView.hidden = YES;
    }
    self.firstImageView.image = original;
    imageView.image = original;
    
    [filteredHairfies setObject:@"original" forKey:@"filter1"];

    _nextBttn.layer.cornerRadius = 2;
    
    self.secondImgBttn.layer.cornerRadius = 2;
    self.secondImgBttn.layer.masksToBounds = YES;
    
    self.editBttn.layer.cornerRadius = self.editBttn.frame.size.height / 2;;
    self.editBttn.layer.masksToBounds = YES;
    self.editBttn.layer.borderColor  = [UIColor whiteColor].CGColor;
    self.editBttn.layer.borderWidth = 2;
    NSData *imgData = [[NSData alloc] initWithData:UIImageJPEGRepresentation((original), 0.5)];
    //int imageSize   = imgData.length;
    NSLog(@"size of image in KB: %f ", imgData.length/1024.0);
    _filtersView.hidden = NO;
    
    [_originalBttn setImage:[UIImage imageNamed:@"original.jpeg"] forState:UIControlStateNormal];
    [_sepiaBttn setImage:[UIImage imageNamed:@"original-sepia.JPG"] forState:UIControlStateNormal];
    [_curveBttn setImage:[UIImage imageNamed:@"original-curve.JPG"] forState:UIControlStateNormal];
    [_instantBttn setImage:[UIImage imageNamed:@"original-instant.JPG"] forState:UIControlStateNormal];
    [_transferBttn setImage:[UIImage imageNamed:@"original-transfer.JPG"] forState:UIControlStateNormal];
    [_processBttn setImage:[UIImage imageNamed:@"original-process.JPG"] forState:UIControlStateNormal];
    [_photoEffectNoirBttn setImage:[UIImage imageNamed:@"original-noir.JPG"] forState:UIControlStateNormal];
    [_vignetteBttn setImage:[UIImage imageNamed:@"original-vignette.JPG"] forState:UIControlStateNormal];
    [_vintageBttn setImage:[UIImage imageNamed:@"original-vintage.JPG"] forState:UIControlStateNormal];
    
    
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
        self.secondImgBttn.backgroundColor = [UIColor clearColor];
        [self.secondImgBttn setTitle:@"" forState:UIControlStateNormal];
             [self.secondImgBttn setTitle:@"" forState:UIControlStateHighlighted];
        Picture *secondPic = self.hairfiePost.picture;
        
       
        original = [self squareCropImage:secondPic.image ToSideLength:320];
        secondPic.image = original;
        self.secondImageView.image = original;
        self.secondImageView.layer.cornerRadius = 2;
        self.secondImageView.layer.masksToBounds = YES;
        imageView.image = original;
        output = original;
        if (hairfiePics.count == 1) {
            [hairfiePics insertObject:secondPic atIndex:1];
        }else {
            [hairfiePics removeObjectAtIndex:1];
            [hairfiePics insertObject:secondPic atIndex:1];
            self.isHairfie = NO;
            
        }
        [filteredHairfies setObject:@"original" forKey:@"filter2"];
        
        if (![[filteredHairfies objectForKey:@"filter2"] isEqualToString:@"original"]) {
            self.imageView.image = [self setImage:original WithFilter:[filteredHairfies objectForKey:@"filter2"]];
        }
    }
//    if (![[filteredHairfies objectForKey:@"filter2"] isEqualToString:@"original"]) {
//        self.imageView.image = [self setImage:original WithFilter:[filteredHairfies objectForKey:@"filter2"]];
//    }
    
  //  [self setupFilters];
}

-(IBAction)goBackToHome:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(IBAction)goBack:(id)sender
{
    [[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2] viewWillAppear:YES];;
    NSLog(@"nav controllers %@", self.navigationController.viewControllers);
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)addSecondPicture:(id)sender
{
    if (self.hairfiePics.count == 1)
        [self performSegueWithIdentifier:@"addSecondPicture" sender:self];
    else
    {
        Picture *picture = [hairfiePics objectAtIndex:1];
        original = [self squareCropImage:picture.image ToSideLength:320];
        imageView.image = [self setImage:picture.image WithFilter:[filteredHairfies objectForKey:@"filter2"]];
        if (self.isSecondHairfie == NO) {
            self.isSecondHairfie = YES;
            self.isHairfie = NO;
        }
    }
}

-(IBAction)modifyFirstPicture:(id)sender {
    
    Picture *picture = [hairfiePics objectAtIndex:0];
   
    original = [self squareCropImage:picture.image ToSideLength:320];
    imageView.image = [self setImage:original WithFilter:[filteredHairfies objectForKey:@"filter1"]];

    if (self.isHairfie == NO) {
        self.isHairfie = YES;
        self.isSecondHairfie = NO;
    }
    
}

-(UIImage*)setImage:(UIImage*)originalImage WithFilter:(NSString*)filterName
{
    
    UIImage *image;
    
    if ([filterName isEqualToString:@"original"])
        image = originalImage;
    else if ([filterName isEqualToString:@"sepia"])
        image = [originalImage toSepia];
    else if ([filterName isEqualToString:@"transfer"])
        image = [originalImage CIPhotoEffectTransfer];
    else if ([filterName isEqualToString:@"curve"])
        image = [originalImage curveFilter];
    else if ([filterName isEqualToString:@"instant"])
        image = [originalImage CIPhotoEffectInstant];
    else if ([filterName isEqualToString:@"process"])
        image = [originalImage CIPhotoEffectProcess];
    else if ([filterName isEqualToString:@"bw"])
        image = [originalImage CIPhotoEffectNoir];
    else if ([filterName isEqualToString:@"vignette"])
        image = [originalImage vignetteWithRadius:0 andIntensity:16];
    else if ([filterName isEqualToString:@"vintage"])
        image = [originalImage vintageFilter];
    
    return image;
    
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
    if (hairfiePics.count == 2) {
     
        if (self.isSecondHairfie == YES) {
         
            [hairfiePics removeObjectAtIndex:1];
            
            self.secondImgBttn.backgroundColor = [UIColor lightGreyHairfie];
            [self.secondImgBttn setTitle:@"+" forState:UIControlStateNormal];

            self.isSecondHairfie = NO;
            [filteredHairfies removeObjectForKey:@"filter2"];
            [self modifyFirstPicture:nil];
        } else {
            
            Picture *picture = [hairfiePics objectAtIndex:1];
            NSString *filter = [filteredHairfies objectForKey:@"filter2"];
            [filteredHairfies removeAllObjects];
            [hairfiePics removeAllObjects];
            [hairfiePics addObject:picture];
            [filteredHairfies setObject:filter forKey:@"filter1"];
            self.firstImageView.image = picture.image;
          
            self.secondImgBttn.backgroundColor = [UIColor lightGreyHairfie];
            [self.secondImgBttn setTitle:@"+" forState:UIControlStateNormal];

            [self modifyFirstPicture:nil];
            
           
        }
    } else {
        [[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2] viewWillAppear:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"setupHairfie"])
    {
        HairfiePostDetailsViewController *details = [segue destinationViewController];
        
        if (hairfiePics.count == 2)
        {
            
            Picture *first = [hairfiePics objectAtIndex:0];
            Picture *second = [hairfiePics objectAtIndex:1];
            UIImage *firstOutput = [self setImage:first.image WithFilter:[filteredHairfies objectForKey:@"filter1"]];
            UIImage *secondOutput =[self setImage:second.image WithFilter:[filteredHairfies objectForKey:@"filter2"]];
            
            
            first.image = firstOutput;
            second.image = secondOutput;
            NSArray *hairfiePictures = [[NSArray alloc] initWithObjects:first,second, nil];
        
            _hairfiePost.pictures = hairfiePictures;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImageWriteToSavedPhotosAlbum(firstOutput, nil, nil, nil);
                UIImageWriteToSavedPhotosAlbum(secondOutput, nil, nil, nil);
            });
        }
        else {
            Picture *first = [hairfiePics objectAtIndex:0];
            UIImage *firstOutput = [self setImage:first.image WithFilter:[filteredHairfies objectForKey:@"filter1"]];
            first.image = firstOutput;
            NSArray *hairfiePictures = [[NSArray alloc] initWithObjects:first, nil];
            _hairfiePost.pictures = hairfiePictures;

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImageWriteToSavedPhotosAlbum(firstOutput, nil, nil, nil);
            });
        }
      
        [details setHairfiePost:_hairfiePost];
        
        
       
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

        UIImage *firstOutput = [self setImage:original WithFilter:[filteredHairfies objectForKey:@"filter1"]];
        
        userProfile.imageFromSegue = firstOutput;
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
    
    imageView.image = [original toSepia];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    if (self.isSecondHairfie)
    {
        [filteredHairfies setObject:@"sepia" forKey:@"filter2"];
    }
    else
        [filteredHairfies setObject:@"sepia" forKey:@"filter1"];
}

-(IBAction)transfer:(id)sender{
    
    imageView.image = [original CIPhotoEffectTransfer];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    if (self.isSecondHairfie)
    {
        [filteredHairfies setObject:@"transfer" forKey:@"filter2"];
    }
    else
        [filteredHairfies setObject:@"transfer" forKey:@"filter1"];
    

}
-(IBAction)curve:(id)sender {
    
    imageView.image = [original curveFilter];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    if (self.isSecondHairfie)
    {
        [filteredHairfies setObject:@"curve" forKey:@"filter2"];
    }
    else
        [filteredHairfies setObject:@"curve" forKey:@"filter1"];
}

-(IBAction)original:(id)sender {
    
    imageView.image = original;
    if (self.isSecondHairfie)
    {
        [filteredHairfies setObject:@"original" forKey:@"filter2"];
    }
    else
        [filteredHairfies setObject:@"original" forKey:@"filter1"];
}
-(IBAction)instant:(id)sender {
    
    imageView.image = [original CIPhotoEffectInstant];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    if (self.isSecondHairfie)
    {
        [filteredHairfies setObject:@"instant" forKey:@"filter2"];
    }
    else
        [filteredHairfies setObject:@"instant" forKey:@"filter1"];
}

-(IBAction)process:(id)sender {
  
    imageView.image = [original CIPhotoEffectProcess];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    if (self.isSecondHairfie)
    {
        [filteredHairfies setObject:@"process" forKey:@"filter2"];
    }
    else
        [filteredHairfies setObject:@"process" forKey:@"filter1"];
}

-(IBAction)photoEffectNoir:(id)sender {
   
    imageView.image = [original CIPhotoEffectNoir];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    if (self.isSecondHairfie)
    {
        [filteredHairfies setObject:@"bw" forKey:@"filter2"];
    }
    else
        [filteredHairfies setObject:@"bw" forKey:@"filter1"];
}

-(IBAction)vignette:(id)sender
{
    imageView.image = [original vignetteWithRadius:0 andIntensity:16];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    if (self.isSecondHairfie)
    {
        [filteredHairfies setObject:@"vignette" forKey:@"filter2"];
    }
    else
        [filteredHairfies setObject:@"vignette" forKey:@"filter1"];
}

- (IBAction)vintage:(id)sender {

    imageView.image = [original vintageFilter];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    if (self.isSecondHairfie)
    {
        [filteredHairfies setObject:@"vintage" forKey:@"filter2"];
    }
    else
        [filteredHairfies setObject:@"vintage" forKey:@"filter1"];
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
