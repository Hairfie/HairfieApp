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
    
    if(self.isHairfie == YES){
        
        
       
        Picture *firstPic = self.hairfiePost.picture;
        original = [self squareCropImage:firstPic.image ToSideLength:320];
      
       
        self.firstImageView.image = original;
        [self.firstImageView setContentMode:UIViewContentModeScaleAspectFill];
        self.firstImageView.layer.cornerRadius = 2;
        self.firstImageView.layer.masksToBounds = YES;
        [hairfiePics addObject:firstPic];
    }
    else
        original = [self squareCropImage:self.userPicture ToSideLength:320];
   
    imageView.image = original;
  
    
    output = original;
  
    [filteredHairfies setObject:@"original" forKey:@"filter1"];

    _nextBttn.layer.cornerRadius = 2;
    self.editBttn.layer.cornerRadius = self.editBttn.frame.size.height / 2;;
    self.editBttn.layer.masksToBounds = YES;
    NSData *imgData = [[NSData alloc] initWithData:UIImageJPEGRepresentation((original), 0.5)];
    //int imageSize   = imgData.length;
    NSLog(@"size of image in KB: %f ", imgData.length/1024.0);
    _filtersView.hidden = NO;
    
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
        if (hairfiePics.count == 1) {
            [hairfiePics addObject:secondPic];
        }else {
            [hairfiePics removeObjectAtIndex:1];
            [hairfiePics insertObject:secondPic atIndex:1];
            self.isHairfie = NO;
            
        }
        [filteredHairfies setObject:@"original" forKey:@"filter2"];
    }
    
  //  [self setupFilters];

    
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
        output = original;
        if (self.isSecondHairfie == NO) {
            self.isSecondHairfie = YES;
            self.isHairfie = NO;
        }
    }
}

-(IBAction)modifyFirstPicture:(id)sender {
    
    Picture *picture = [hairfiePics objectAtIndex:0];
    original =[self squareCropImage:picture.image ToSideLength:320];
    imageView.image = [self setImage:imageView.image WithFilter:[filteredHairfies objectForKey:@"filter1"]];
    output = original;

    if (self.isHairfie == NO) {
        self.isHairfie = YES;
        self.isSecondHairfie = NO;
    }
    
}

-(UIImage*)setImage:(UIImage*)image WithFilter:(NSString*)filterName
{
    if ([filterName isEqualToString:@"original"])
        image = original;
    else if ([filterName isEqualToString:@"sepia"])
        image = [original toSepia];
    else if ([filterName isEqualToString:@"transfer"])
        image = [original CIPhotoEffectTransfer];
    else if ([filterName isEqualToString:@"curve"])
        image = [original curveFilter];
    else if ([filterName isEqualToString:@"instant"])
        image = [original CIPhotoEffectInstant];
    else if ([filterName isEqualToString:@"process"])
        image = [original CIPhotoEffectProcess];
    else if ([filterName isEqualToString:@"bw"])
        image = [original CIPhotoEffectNoir];
    else if ([filterName isEqualToString:@"vignette"])
        image = [original vignetteWithRadius:0 andIntensity:16];
    else if ([filterName isEqualToString:@"vintage"])
        image = [original vintageFilter];
    
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
            [self.secondImageView setImage:[UIImage imageNamed:@"add-second-picture.png"]];
            self.isSecondHairfie = NO;
            [filteredHairfies removeObjectForKey:@"filter2"];
            [self modifyFirstPicture:self];
        } else {
            
            Picture *picture = [hairfiePics objectAtIndex:1];
            NSString *filter = [filteredHairfies objectForKey:@"filter2"];
            [filteredHairfies removeAllObjects];
            [hairfiePics removeAllObjects];
            [hairfiePics addObject:picture];
            [filteredHairfies setObject:filter forKey:@"filter1"];
            self.firstImageView.image = picture.image;
            [self.secondImageView setImage:[UIImage imageNamed:@"add-second-picture.png"]];
            [self modifyFirstPicture:self];
            
           
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
            NSArray *hairfiePictures = [[NSArray alloc] initWithObjects:firstOutput,secondOutput, nil];
            _hairfiePost.pictures = hairfiePictures;
            
        }
        else {
            Picture *first = [hairfiePics objectAtIndex:0];
            UIImage *firstOutput = [self setImage:first.image WithFilter:[filteredHairfies objectForKey:@"filter1"]];
            NSArray *hairfiePictures = [[NSArray alloc] initWithObjects:firstOutput, nil];
            _hairfiePost.pictures = hairfiePictures;

        }
            
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
    
    imageView.image = [original toSepia];
    //imageView.image = sepia;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    output = sepia;
    
    if (self.isSecondHairfie)
    {
        [filteredHairfies setObject:@"sepia" forKey:@"filter2"];
    }
    else
        [filteredHairfies setObject:@"sepia" forKey:@"filter1"];
}

-(IBAction)transfer:(id)sender
{
    
    imageView.image = [original CIPhotoEffectTransfer];
   // imageView.image = transfer;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    output = transfer;
    
    if (self.isSecondHairfie)
    {
        [filteredHairfies setObject:@"transfer" forKey:@"filter2"];
    }
    else
        [filteredHairfies setObject:@"transfer" forKey:@"filter1"];
    

}
-(IBAction)curve:(id)sender {
    
    
    imageView.image = [original curveFilter];
    // imageView.image = curve;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    output = curve;
    if (self.isSecondHairfie)
    {
        [filteredHairfies setObject:@"curve" forKey:@"filter2"];
    }
    else
        [filteredHairfies setObject:@"curve" forKey:@"filter1"];
}

-(IBAction)original:(id)sender {
    imageView.image = original;
    output = original;
    if (self.isSecondHairfie)
    {
        [filteredHairfies setObject:@"original" forKey:@"filter2"];
    }
    else
        [filteredHairfies setObject:@"original" forKey:@"filter1"];
}
-(IBAction)instant:(id)sender {
    
    imageView.image = [original CIPhotoEffectInstant];
    //imageView.image = instant;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    output = instant;
    if (self.isSecondHairfie)
    {
        [filteredHairfies setObject:@"instant" forKey:@"filter2"];
    }
    else
        [filteredHairfies setObject:@"instant" forKey:@"filter1"];
}

-(IBAction)process:(id)sender {
  
    imageView.image = [original CIPhotoEffectProcess];
    //imageView.image = process;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    output = process;
    if (self.isSecondHairfie)
    {
        [filteredHairfies setObject:@"process" forKey:@"filter2"];
    }
    else
        [filteredHairfies setObject:@"process" forKey:@"filter1"];
}

-(IBAction)photoEffectNoir:(id)sender {
   
    imageView.image = [original CIPhotoEffectNoir];
    //imageView.image = photoEffectNoir;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    output = photoEffectNoir;
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
 //   imageView.image = vignette;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    output = vignette;
    if (self.isSecondHairfie)
    {
        [filteredHairfies setObject:@"vignette" forKey:@"filter2"];
    }
    else
        [filteredHairfies setObject:@"vignette" forKey:@"filter1"];
}

- (IBAction)vintage:(id)sender {

    imageView.image = [original vintageFilter];
   // imageView.image = vintage;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    output = vintage;
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
