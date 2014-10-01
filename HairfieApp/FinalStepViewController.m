//
//  FinalStepViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 17/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "FinalStepViewController.h"
#import "SecondStepSalonPhoneViewController.h"
#import "FinalStepAddressViewController.h"
#import "FinalStepTimetableViewController.h"
#import "HairdresserTableViewCell.h"
#import "FinalStepDescriptionViewController.h"
#import "Address.h"
#import "Hairdresser.h"
#import "PictureUploader.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ClaimAddHairdresserViewController.h"

@interface FinalStepViewController ()

@end

@implementation FinalStepViewController
{
    UIAlertView *chooseCameraType;
    UIImagePickerController *imagePicker;
    Hairdresser *hairdresserForEditing;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setButtonSelected:_infoBttn andBringViewUpfront:_infoView];
    
    _claim.timetable = [[Timetable alloc] initEmpty];
    _claim.pictures = [[NSMutableArray alloc] init];
    _phoneLabel.text = _claim.phoneNumber;

    _addressLabel.text = [_claim.address displayAddress];
    _nameLabel.text = _claim.name;
    
   
    _validateBttn.layer.cornerRadius = 5;
    _validateBttn.layer.masksToBounds = YES;
    _addHairfiesBttn.layer.cornerRadius = 5;
    _addHairfiesBttn.layer.masksToBounds = YES;
    
 
    
    UIView *borderBttn =[[UIView alloc] initWithFrame:CGRectMake(105, 99, 110, 110)];
    borderBttn.backgroundColor = [UIColor whiteColor];
    borderBttn.alpha = 0.2;
    borderBttn.layer.cornerRadius = borderBttn.frame.size.height / 2;
    borderBttn.clipsToBounds = YES;
    
    UIButton *addPictureBttn = [[UIButton alloc] initWithFrame:CGRectMake(110, 104, 100, 100)];
    addPictureBttn.layer.cornerRadius = addPictureBttn.frame.size.height / 2;
    addPictureBttn.clipsToBounds = YES;
    addPictureBttn.backgroundColor = [UIColor redHairfie];
    [addPictureBttn addTarget:self
                       action:@selector(chooseCameraType)
             forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:borderBttn];
    [self.view addSubview:addPictureBttn];
    
    
    UILabel *addPictureLabel = [[UILabel alloc] initWithFrame:CGRectMake(135, 124, 50, 50)];
    addPictureLabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:15];
    addPictureLabel.textColor = [UIColor whiteColor];
    addPictureLabel.text = @"Add Pictures";
    addPictureLabel.textAlignment = NSTextAlignmentCenter;
    addPictureLabel.numberOfLines = 2;
    [self.view addSubview:addPictureLabel];
    
    // Do any additional setup after loading the view.
}




-(IBAction)changePage:(id)sender {
    
    UIPageControl *pager = sender;
    CGPoint offset = CGPointMake(pager.currentPage * _imageSliderView.frame.size.width, 0);
    [_imageSliderView setContentOffset:offset animated:YES];
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollview
{
    if (scrollview == _imageSliderView)
    {
        
        CGFloat pageWidth = scrollview.frame.size.width;
        int page = floor((scrollview.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        _pageControl.currentPage = page;
    }
}

-(void) setupGallery:(NSArray*) pictures
{
    if ([pictures count] == 1)
        _pageControl.hidden = YES;
    if ([pictures count] == 0)
    {
        _pageControl.numberOfPages = 1;
        _pageControl.hidden = YES;
        CGRect frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        frame.size = _imageSliderView.frame.size;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.image = [UIImage imageNamed:@"default-picture.jpg"];
        imageView.contentMode = UIViewContentModeScaleToFill;
        [_imageSliderView addSubview:imageView];
    }
    else {
        
        _pageControl.numberOfPages = [pictures count];
        for (int i = 0; i < [pictures count]; i++) {
            CGRect frame;
            frame.origin.x = _imageSliderView.frame.size.width * i;
            frame.origin.y = 0;
            frame.size = _imageSliderView.frame.size;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
            
            [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:[pictures objectAtIndex:i]]
                                                                options:0
                                                               progress:^(NSInteger receivedSize, NSInteger expectedSize) { }
                                                              completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
             {
                 if (image && finished)
                 {
                     imageView.image = image;
                 }
             }];
            
            imageView.contentMode = UIViewContentModeScaleToFill;
            [_imageSliderView addSubview:imageView];
        }
        
    }
    _imageSliderView.pagingEnabled = YES;
    _imageSliderView.contentSize = CGSizeMake(_imageSliderView.frame.size.width * [pictures count], _imageSliderView.frame.size.height);
}

-(void)viewWillAppear:(BOOL)animated
{
    _phoneLabel.text = _claim.phoneNumber;
    _addressLabel.text = [_claim.address displayAddress];
    _nameLabel.text = _claim.name;
    if ([_claim.hairdressers count] == 0)
        _hairdresserTableView.hidden = YES;
    else
         _hairdresserTableView.hidden = NO;
    [self setupGallery:_claim.pictures];
}

-(IBAction)changeTab:(id)sender {
    if(sender == _infoBttn) {
        [self setButtonSelected:_infoBttn andBringViewUpfront:_infoView];
    } else if(sender == _hairfieBttn) {
        [self setButtonSelected:_hairfieBttn andBringViewUpfront:_hairfieView];
    } else if(sender == _hairdresserBttn) {
        [self setButtonSelected:_hairdresserBttn andBringViewUpfront:_hairdresserView];
    } else if(sender == _priceAndSaleBttn) {
        [self setButtonSelected:_priceAndSaleBttn andBringViewUpfront:_priceAndSaleView];
    }
}


-(void)setButtonSelected:(UIButton*) button andBringViewUpfront:(UIView*) view {
    
    [self unSelectAll];
    view.hidden = NO;
    [_containerView bringSubviewToFront:view];
    [button setBackgroundColor:[UIColor colorWithRed:50/255.0f green:67/255.0f blue:87/255.0f alpha:1]];
}

-(void) setNormalStateColor:(UIButton*) button
{
    [button setBackgroundColor:[UIColor colorWithRed:50/255.0f green:67/255.0f blue:87/255.0f alpha:0.9]];
}

-(void) unSelectAll
{
    _infoView.hidden = YES;
    _hairfieView.hidden = YES;
    _hairdresserView.hidden = YES;
    _priceAndSaleView.hidden = YES;
    [self setNormalStateColor:_infoBttn];
    [self setNormalStateColor:_hairfieBttn];
    [self setNormalStateColor:_hairdresserBttn];
    [self setNormalStateColor:_priceAndSaleBttn];
}


-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)modifyPhoneNumber:(id)sender
{
    [self performSegueWithIdentifier:@"claimPhone" sender:self];
}

-(IBAction)modifyName:(id)sender
{
    [self performSegueWithIdentifier:@"claimSalon" sender:self];
}

-(IBAction)modifyAddress:(id)sender
{
    [self performSegueWithIdentifier:@"claimAddress" sender:self];
}

-(IBAction)modifyTimetable:(id)sender
{
    [self performSegueWithIdentifier:@"claimTimetable" sender:self]; 
}

-(IBAction)modifyDesc:(id)sender
{
    [self performSegueWithIdentifier:@"claimDesc" sender:self];
}

-(IBAction)modifyHairdresser:(id)sender
{
    _isEditingHairdresser = NO;
    [self performSegueWithIdentifier:@"claimHairdresser" sender:self];
}

-(IBAction)modifyService:(id)sender
{
    [self performSegueWithIdentifier:@"claimService" sender:self];
}
-(void)chooseCameraType
{
    
    chooseCameraType = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Choose camera type", @"Login_Sign_Up", nil) message:NSLocalizedStringFromTable(@"Take picture or pick one from the saved photos", @"Login_Sign_Up", nil) delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:NSLocalizedStringFromTable(@"Camera", @"Login_Sign_Up", nil), NSLocalizedStringFromTable(@"Library", @"Login_Sign_Up", nil),nil];
    chooseCameraType.delegate = self;
    [chooseCameraType show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    imagePicker = [[UIImagePickerController alloc]init];
    [imagePicker setDelegate:self];
    if (buttonIndex == 2) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            //_camera.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.allowsEditing = YES;
            
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    } if (buttonIndex == 1) {
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            imagePicker.showsCameraControls = NO;
            imagePicker.allowsEditing = YES;
            
            imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
            [self initOverlayView];
            
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }
}

-(void) initOverlayView
{
    
    UIView *overlayView = [[UIView alloc] init];
    
    overlayView.frame =  imagePicker.cameraOverlayView.frame;
    
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    navigationView.backgroundColor = [UIColor blackHairfie];
    
    
    UIImage *goBackImg = [UIImage imageNamed:@"arrow-nav.png"];
    UIButton *goBackButton = [UIButton
                              buttonWithType:UIButtonTypeCustom];
    [goBackButton setImage:goBackImg forState:UIControlStateNormal];
    [goBackButton addTarget:self action:@selector(cancelTakePicture) forControlEvents:UIControlEventTouchUpInside];
    [goBackButton setFrame:CGRectMake(10, 22, 20, 20)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(67, 20, 186, 23)];
    titleLabel.text = NSLocalizedStringFromTable(@"Take a profile picture", @"Login_Sign_Up", nil);
    titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    [navigationView addSubview:titleLabel];
    [navigationView addSubview:goBackButton];
    [overlayView addSubview:navigationView];
    
    
    UIImage *takePictureImg = [UIImage imageNamed:@"take-picture-button.png"];
    
    UIButton *takePictureButton = [UIButton
                                   buttonWithType:UIButtonTypeCustom];
    [takePictureButton setImage:takePictureImg forState:UIControlStateNormal];
    [takePictureButton addTarget:self action:@selector(snapPicture) forControlEvents:UIControlEventTouchUpInside];
    [takePictureButton setFrame:CGRectMake(122, 401, 77, 77)];
    
    takePictureButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    UIImage *switchCameraImg = [UIImage imageNamed:@"switch-camera-button.png"];
    
    UIButton *switchCameraButton = [UIButton
                                    buttonWithType:UIButtonTypeCustom];
    [switchCameraButton setImage:switchCameraImg forState:UIControlStateNormal];
    [switchCameraButton addTarget:self action:@selector(switchCamera) forControlEvents:UIControlEventTouchUpInside];
    [switchCameraButton setFrame:CGRectMake(268, 75, 32, 32)];
    
    [overlayView addSubview:switchCameraButton];
    [overlayView addSubview:takePictureButton];
    
    imagePicker.cameraOverlayView = overlayView;
}



-(void) uploadSalonImage:(UIImage *)image
{
   
    PictureUploader *pictureUploader = [[PictureUploader alloc] init];
    
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
       
        NSLog(@"Error : %@", error.description);
    };
    void (^loadSuccessBlock)(NSString *) = ^(NSString *fileName){
        [_claim.pictures addObject:fileName];
        NSLog(@"finame %@ uploaded", fileName);
        NSLog(@"pictures %@", _claim.pictures);
    };
    
    [pictureUploader uploadImage:image toContainer:@"business-pictures" success:loadSuccessBlock failure:loadErrorBlock];
}

- (void)switchCamera
{
    if (imagePicker.cameraDevice == UIImagePickerControllerCameraDeviceRear)
    {
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
    else
    {
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
}

-(void)snapPicture
{
    [imagePicker takePicture];
}

-(void) cancelTakePicture
{
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  // set this bish
    UIImage *image;
    if([info valueForKey:UIImagePickerControllerEditedImage]) {
        image = [info valueForKey:UIImagePickerControllerEditedImage];
    } else {
        image = [info valueForKey:UIImagePickerControllerOriginalImage];
    }
    
    
    [self uploadSalonImage:image];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"claimSalon"])
    {
        
        SecondStepSalonPhoneViewController *salon = [segue destinationViewController];
        salon.isFinalStep = YES;
        salon.isExisting = YES;
        salon.isSalon = YES;
        salon.headerTitle = @"Salon's name";
        salon.textFieldPlaceHolder = @"Salon's name";
        salon.textFieldFromSegue = _claim.name;
        
    }
    
    if ([segue.identifier isEqualToString:@"claimPhone"])
    {
        
        SecondStepSalonPhoneViewController *phone = [segue destinationViewController];
        phone.isFinalStep = YES;
        phone.isExisting = YES;
        phone.isSalon = NO;
        phone.headerTitle = @"Phone Number";
        phone.textFieldPlaceHolder = @"Phone number";
        phone.textFieldFromSegue = _claim.phoneNumber;
        
    }
    if ([segue.identifier isEqualToString:@"claimAddress"])
    {
        FinalStepAddressViewController *claimAddress = [segue destinationViewController];
        claimAddress.address = _claim.address;
    
    }
    
    if ([segue.identifier isEqualToString:@"claimTimetable"])
    {
        FinalStepTimetableViewController *claimTimetable = [segue destinationViewController];
            claimTimetable.timeTable = _claim.timetable;
        
    }
    if ([segue.identifier isEqualToString:@"claimDesc"])
    {
        FinalStepDescriptionViewController *claimDesc = [segue destinationViewController];
        claimDesc.desc = _claim.desc;
    }
    if ([segue.identifier isEqualToString:@"claimHairdresser"])
    {
        ClaimAddHairdresserViewController *claimHairdresser = [segue destinationViewController];
        
        claimHairdresser.hairdressersClaimed = _claim.hairdressers;
        if (_isEditingHairdresser == YES)
            claimHairdresser.hairdresserFromSegue = hairdresserForEditing;
        _isEditingHairdresser = NO;
    }
    
}



// HAIRDRESSER TAB TABLE VIEW


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"hairdresserCell";
    HairdresserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HairdresserTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Hairdresser *hairdresser = [_claim.hairdressers objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.fullName.text = [hairdresser displayFullName];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_claim.hairdressers count];
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    hairdresserForEditing = [_claim.hairdressers objectAtIndex:indexPath.row];
    _isEditingHairdresser = YES;
    [self performSegueWithIdentifier:@"claimHairdresser" sender:self];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
