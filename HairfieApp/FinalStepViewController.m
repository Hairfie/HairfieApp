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
#import "PricesTableViewCell.h"
#import "FinalStepDescriptionViewController.h"
#import "Address.h"
#import "Hairdresser.h"
#import "PictureUploader.h"
#import "Picture.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ClaimAddHairdresserViewController.h"
#import "ClaimAddPricesSalesViewController.h"
#import "HomeViewController.h"
#import "SalonDetailViewController.h"
#import "AppDelegate.h"


@interface FinalStepViewController ()

@end

@implementation FinalStepViewController
{
    UIAlertView *chooseCameraType;
    UIImagePickerController *imagePicker;
    Hairdresser *hairdresserForEditing;
    Service *serviceForEditing;
    NSMutableArray *pictureForGallery;
    AppDelegate *appDelegate;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [self setupGallery:nil];
    [self setButtonSelected:_infoBttn andBringViewUpfront:_infoView];
    pictureForGallery = [[NSMutableArray alloc] init];
    _claim.timetable = [[Timetable alloc] initEmpty];
    _claim.pictures = [[NSMutableArray alloc] init];
    _phoneLabel.text = _claim.phoneNumber;

    _addressLabel.text = [_claim.address displayAddress];
    _nameLabel.text = _claim.name;
    
   
    _validateBttn.layer.cornerRadius = 5;
    _validateBttn.layer.masksToBounds = YES;
    _addHairfiesBttn.layer.cornerRadius = 5;
    _addHairfiesBttn.layer.masksToBounds = YES;
    
    
    
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
    
    if (pictures == nil)
    {
        _pageControl.hidden = YES;
        _pageControl.numberOfPages = [pictures count] + 1;
        CGRect frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        frame.size = _imageSliderView.frame.size;
        UIView *bgView = [[UIView alloc] initWithFrame:frame];
        bgView.backgroundColor = [UIColor lightGreyHairfie];
        [_imageSliderView addSubview:bgView];
        UIView *borderBttn =[[UIView alloc] initWithFrame:CGRectMake(105, 35, 110, 110)];
        borderBttn.backgroundColor = [UIColor whiteColor];
        borderBttn.alpha = 0.2;
        borderBttn.layer.cornerRadius = borderBttn.frame.size.height / 2;
        borderBttn.clipsToBounds = YES;
        
        UIButton *addPictureBttn = [[UIButton alloc] initWithFrame:CGRectMake(110, 40, 100, 100)];
        addPictureBttn.layer.cornerRadius = addPictureBttn.frame.size.height / 2;
        addPictureBttn.clipsToBounds = YES;
        addPictureBttn.backgroundColor = [UIColor colorWithRed:250/255.0f green:66/255.0f blue:77/255.0f alpha:1];
        [addPictureBttn addTarget:self
                           action:@selector(chooseCameraType)
                 forControlEvents:UIControlEventTouchUpInside];
        
        [_imageSliderView addSubview:borderBttn];
        [_imageSliderView addSubview:addPictureBttn];
    
        UILabel *addPictureLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 60, 60, 60)];
        addPictureLabel.minimumScaleFactor = 0.5;
        addPictureLabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:15];
        addPictureLabel.textColor = [UIColor whiteColor];
        addPictureLabel.text = NSLocalizedStringFromTable(@"Add Pictures", @"Claim", nil);         addPictureLabel.textAlignment = NSTextAlignmentCenter;
        addPictureLabel.numberOfLines = 3;
       
        [_imageSliderView addSubview:addPictureLabel];
    }
    if ([pictures count] >= 1)
    {
        _pageControl.hidden = NO;
        _pageControl.numberOfPages = [pictures count] + 1;
        for (int i = 0; i < [pictures count]; i++) {
            Picture *pic = [pictures objectAtIndex:i];
            CGRect frame;
            frame.origin.x = 320 + _imageSliderView.frame.size.width * i;
            frame.origin.y = 0;
            frame.size = _imageSliderView.frame.size;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
            [imageView sd_setImageWithURL:[NSURL URLWithString:pic.url]
                                placeholderImage:[UIColor imageWithColor:[UIColor lightGreyHairfie]]];
            
            imageView.contentMode = UIViewContentModeScaleToFill;
            [_imageSliderView addSubview:imageView];
        }
        
    }
    _imageSliderView.pagingEnabled = YES;
    _imageSliderView.contentSize = CGSizeMake(320 + _imageSliderView.frame.size.width *
                                              [pictures count], _imageSliderView.frame.size.height);
}

-(void)viewWillAppear:(BOOL)animated
{
    
    
    if (_businessToManage != nil)
    {
        NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
        if ([language isEqualToString:@"fr"]) {
            _validateBttnWidth.constant = 83;
            _validateBttnXpos.constant = 229;
        } else {
            _validateBttnXpos.constant = 255;
            _validateBttnWidth.constant = 53;
        }
        
        [_validateBttn setTitle:NSLocalizedStringFromTable(@"Update",@"Claim", nil) forState:UIControlStateNormal];
       
        _phoneLabel.text = _businessToManage.phoneNumber;
         _addressLabel.text = [_businessToManage.address displayAddress];
        _nameLabel.text = _businessToManage.name;
        [self setupGallery:_businessToManage.pictures];
        _menuButton.hidden = NO;
        _navButton.hidden = YES;
        if ([_businessToManage.hairdressers count] == 0)
            _hairdresserTableView.hidden = YES;
        else
            _hairdresserTableView.hidden = NO;
        if (_businessToManage.services == (id)[NSNull null])
            _serviceTableView.hidden = YES;
        else
            _serviceTableView.hidden = NO;
        
        [_serviceTableView reloadData];
        [_hairdresserTableView reloadData];
    }
    else
    {
        [self setupGallery:_claim.pictures];
        _phoneLabel.text = _claim.phoneNumber;
        _addressLabel.text = [_claim.address displayAddress];
        _nameLabel.text = _claim.name;
        _menuButton.hidden = YES;
        if ([_claim.hairdressers count] == 0)
            _hairdresserTableView.hidden = YES;
        else
            _hairdresserTableView.hidden = NO;
        
        if ([_claim.services count] == 0)
            _serviceTableView.hidden = YES;
        else
            _serviceTableView.hidden = NO;
        [_serviceTableView reloadData];
        [_hairdresserTableView reloadData];
        
    }
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
    [button.imageView setTintColor:[UIColor salonDetailTab]];
    [button setImage:button.imageView.image forState:UIControlStateNormal];
    button.imageView.image = [button.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_containerView bringSubviewToFront:view];
    
    UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, button.frame.size.height, button.frame.size.width, 3)];
    bottomBorder.backgroundColor = [UIColor salonDetailTab];
    bottomBorder.tag = 1;
    [button addSubview:bottomBorder];
    view.hidden = NO;
}

-(void) setNormalStateColor:(UIButton*) button
{
    [button.imageView setTintColor:[UIColor greyHairfie]];
    [button setImage:button.imageView.image forState:UIControlStateNormal];
    button.imageView.image = [button.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    for (UIView *subView in button.subviews) {
        if (subView.tag == 1) [subView removeFromSuperview];
    }
    //[button setBackgroundColor:[UIColor colorWithRed:50/255.0f green:67/255.0f blue:87/255.0f alpha:0.9]];
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
    _isEditingService = NO;
    [self performSegueWithIdentifier:@"claimService" sender:self];
}
-(void)chooseCameraType
{
    
    chooseCameraType = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Choose camera type", @"Login_Sign_Up", nil) message:NSLocalizedStringFromTable(@"Take picture or pick one from the saved photos", @"Login_Sign_Up", nil) delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:NSLocalizedStringFromTable(@"Camera", @"Login_Sign_Up", nil), NSLocalizedStringFromTable(@"Library", @"Login_Sign_Up", nil),nil];
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
    void (^loadSuccessBlock)(Picture *) = ^(Picture *picture) {
        
        if (_businessToManage != nil)
        {
            [_businessToManage.pictures addObject:picture];
            NSLog(@"test %@", picture.url);
        }
        else
        {
            [_claim.pictures addObject:picture];

        }
        
        [imagePicker dismissViewControllerAnimated:YES completion:nil];

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
    
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"claimSalon"])
    {
        
        SecondStepSalonPhoneViewController *salon = [segue destinationViewController];
        salon.isFinalStep = YES;
        salon.isExisting = YES;
        salon.isSalon = YES;
        salon.headerTitle = NSLocalizedStringFromTable(@"Salon's name", @"Claim", nil);
        salon.textFieldPlaceHolder = NSLocalizedStringFromTable(@"Salon's name", @"Claim", nil);
        if (_businessToManage != nil)
            salon.textFieldFromSegue = _businessToManage.name;
        else
            salon.textFieldFromSegue = _claim.name;
        
    }
    
    if ([segue.identifier isEqualToString:@"claimPhone"])
    {
        
        SecondStepSalonPhoneViewController *phone = [segue destinationViewController];
        phone.isFinalStep = YES;
        phone.isExisting = YES;
        phone.isSalon = NO;
        phone.headerTitle = NSLocalizedStringFromTable(@"Phone number", @"Claim", nil);
        phone.textFieldPlaceHolder = NSLocalizedStringFromTable(@"Phone number", @"Claim", nil);
        if (_businessToManage != nil)
            phone.textFieldFromSegue = _businessToManage.phoneNumber;
        else
        phone.textFieldFromSegue = _claim.phoneNumber;
        
    }
    if ([segue.identifier isEqualToString:@"claimAddress"])
    {
        FinalStepAddressViewController *claimAddress = [segue destinationViewController];
        if (_businessToManage != nil)
            claimAddress.address = _businessToManage.address;
        else
            claimAddress.address = _claim.address;
    
    }
    
    if ([segue.identifier isEqualToString:@"claimTimetable"])
    {
        FinalStepTimetableViewController *claimTimetable = [segue destinationViewController];
        if (_businessToManage != nil)
            claimTimetable.timeTable = _businessToManage.timetable;
        else
            claimTimetable.timeTable = _claim.timetable;
        
    }
    if ([segue.identifier isEqualToString:@"claimDesc"])
    {
        FinalStepDescriptionViewController *claimDesc = [segue destinationViewController];
        if (_businessToManage != nil)
            claimDesc.desc = _businessToManage.desc;
        else
            claimDesc.desc = _claim.desc;
    }
    if ([segue.identifier isEqualToString:@"claimHairdresser"])
    {
        ClaimAddHairdresserViewController *claimHairdresser = [segue destinationViewController];
        if (_businessToManage != nil)
        {
            if  (_businessToManage.hairdressers != (id)[NSNull null])
                
                claimHairdresser.hairdressersClaimed = _businessToManage.hairdressers;
            else
    
                claimHairdresser.hairdressersClaimed = [[NSMutableArray alloc] init];
        }
        else
            claimHairdresser.hairdressersClaimed = _claim.hairdressers;
        
        if (_isEditingHairdresser == YES)
            claimHairdresser.hairdresserFromSegue = hairdresserForEditing;
        _isEditingHairdresser = NO;
    }
    if ([segue.identifier isEqualToString:@"claimService"])
    {
        
        ClaimAddPricesSalesViewController *claimService = [segue destinationViewController];
        
        if (_businessToManage != nil)
        {
        if (_businessToManage.services != (id)[NSNull null])
            claimService.serviceClaimed = _businessToManage.services;
        else
            claimService.serviceClaimed = [[NSMutableArray alloc] init];
        }
        else
            claimService.serviceClaimed = _claim.services;
        if (_isEditingService == YES)
            claimService.serviceFromSegue = serviceForEditing;
        _isEditingService = NO;
        
    }
    
    if ([segue.identifier isEqualToString:@"toSalonDetail"])
    {
        SalonDetailViewController *salonDetail = [segue destinationViewController];
        salonDetail.didClaim = YES;
        salonDetail.business = _businessToManage;
    }
}



// TABLE VIEW

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _hairdresserTableView)
    {
        static NSString *CellIdentifier = @"hairdresserCell";
        HairdresserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HairdresserTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        Hairdresser *hairdresser = [[Hairdresser alloc] init];
        
        if (_businessToManage != nil)
        {
            hairdresser = [_businessToManage.hairdressers objectAtIndex:indexPath.row];
            
        }
        else
            hairdresser = [_claim.hairdressers objectAtIndex:indexPath.row];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.fullName.text = [hairdresser displayFullName];
        cell.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0);
        return cell;
    }
    if (tableView == _serviceTableView)
    {
        static NSString *CellIdentifier = @"priceCell";
        PricesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PricesTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        Service *service;
        if (_businessToManage != nil)
        {
           service =[_businessToManage.services objectAtIndex:indexPath.row];
        }
        else
            service = [_claim.services objectAtIndex:indexPath.row];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.itemName.text = service.label;
        cell.price.text = [service.price formatted];
        cell.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0);
        return cell;
    }
    
    return nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _hairdresserTableView)
    {
    if (_businessToManage.hairdressers != (id)[NSNull null])
        return [_businessToManage.hairdressers count];
    else
        return [_claim.hairdressers count];
    }
    
    if (tableView == _serviceTableView)
    {
        if (_businessToManage.services != (id)[NSNull null])
            return [_businessToManage.services count];
        else
            return [_claim.services count];
    }
    return 1;
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _hairdresserTableView)
    {
    if (_businessToManage != nil)
        hairdresserForEditing = [_businessToManage.hairdressers objectAtIndex:indexPath.row];
    else
        hairdresserForEditing = [_claim.hairdressers objectAtIndex:indexPath.row];
    _isEditingHairdresser = YES;
    [self performSegueWithIdentifier:@"claimHairdresser" sender:self];
    }
    if (tableView == _serviceTableView)
    {
        NSLog(@"SERVICE %@", [_businessToManage.services objectAtIndex:indexPath.row]);
        if (_businessToManage != nil)
            serviceForEditing = [_businessToManage.services objectAtIndex:indexPath.row];
        else
            serviceForEditing = [_claim.services objectAtIndex:indexPath.row];
        _isEditingService = YES;
        [self performSegueWithIdentifier:@"claimService" sender:self];
    }
}

-(IBAction)claimThisBusiness:(id)sender
{
    
    if (_businessToManage != nil)
        
    {  void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        
        NSLog(@"Error : %@", error.description);
    };
        void (^loadSuccessBlock)(NSArray *) = ^(NSArray *results) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"currentUser" object:self];
            [self performSegueWithIdentifier:@"toSalonDetail" sender:self];
        };

        [_businessToManage updateWithSuccess:loadSuccessBlock failure:loadErrorBlock];
        
    } else {
   
        void (^loadErrorBlock)(NSError *) = ^(NSError *error){
            NSLog(@"Error : %@", error.description);
        };
        void (^loadSuccessBlock)(NSDictionary *) = ^(NSDictionary *results) {
            _businessToManage = [[Business alloc] initWithDictionary:results];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"currentUser" object:self];
            [self performSegueWithIdentifier:@"toSalonDetail" sender:self];
        };
    
        [_claim submitClaimWithSuccess:loadSuccessBlock failure:loadErrorBlock];
    }
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
