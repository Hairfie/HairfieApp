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
#import "ClaimServiceTableViewCell.h"
#import "Address.h"
#import "BusinessMember.h"
#import "Picture.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ClaimAddHairdresserViewController.h"
#import "ClaimAddPricesSalesViewController.h"
#import "HomeViewController.h"
#import "BusinessViewController.h"
#import "AppDelegate.h"
#import "NSString+PhoneFormatter.h"
#import "HairfieNotifications.h"
#import "UIImage+Resize.h"


@interface FinalStepViewController ()

@end

@implementation FinalStepViewController
{
    UIImagePickerController *imagePicker;
    BusinessMember *businessMemberForEditing;
    Service *serviceForEditing;
    NSMutableArray *pictureForGallery;
    AppDelegate *appDelegate;
    NSInteger serviceIndex;

    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearHairdresser:)
                                                 name:@"clearHairdresser"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearService:)
                                                 name:@"clearService"
                                               object:nil];


    [self setupGallery:nil];
  
    [self.view bringSubviewToFront:self.topBarView];
    [self setButtonSelected:_infoBttn];
    pictureForGallery = [[NSMutableArray alloc] init];

    if(![_businessToManage.timetable isKindOfClass:[Timetable class]]) {
       _businessToManage.timetable = [[Timetable alloc] initEmpty];
    }
    
    _validateBttn.layer.cornerRadius = 5;
    _validateBttn.layer.masksToBounds = YES;
//    _addHairfiesBttn.layer.cornerRadius = 5;
//    _addHairfiesBttn.layer.masksToBounds = YES;
//    
    
    
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
            frame.origin.x = self.view.frame.size.width + self.view.frame.size.width * i;
            
            frame.origin.y = 0;
            frame.size = _imageSliderView.frame.size;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
            [imageView sd_setImageWithURL:pic.url
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
        
        if (_businessToManage.timetable.monday.count != 0)
        {
            TimeWindow *tw = [_businessToManage.timetable.monday objectAtIndex:0];
            NSString *dayFormatted = [NSString stringWithFormat:@"%@ %@ ...", NSLocalizedStringFromTable(@"Monday", @"Claim", nil), [tw timeWindowFormatted]];
            [_timetableBttn setTitle:dayFormatted forState:UIControlStateNormal];
        }
        [_validateBttn setTitle:NSLocalizedStringFromTable(@"Update",@"Claim", nil) forState:UIControlStateNormal];
       
        
        _phoneLabel.text = [_businessToManage.phoneNumber formatPhoneNumber:_businessToManage.phoneNumber];
         _addressLabel.text = [_businessToManage.address displayAddress];
        _nameLabel.text = _businessToManage.name;
        [self setupGallery:_businessToManage.pictures];
        _menuButton.hidden = NO;
        _navButton.hidden = YES;
        
        if ([_businessToManage.activeHairdressers count] == 0)
            _hairdresserTableView.hidden = YES;
        else
            _hairdresserTableView.hidden = NO;
        if (_businessToManage.services == (id)[NSNull null])
            _serviceTableView.hidden = YES;
        else
            _serviceTableView.hidden = NO;
       // _addHairfiesLbl.text = NSLocalizedStringFromTable(@"hairfie claim update", @"Claim", nil);
        [_serviceTableView reloadData];
        [_hairdresserTableView reloadData];
    }
    if (self.isSegueFromBusinessDetail == YES){
        _menuButton.hidden = YES;
        _navButton.hidden = NO;
    }
    else {
        _menuButton.hidden = NO;
        _navButton.hidden = YES;

    }
}

-(IBAction)changeTab:(id)sender {
    [self setButtonSelected:sender];
}

-(void)decorateButton:(UIButton *)aButton withImage:(NSString *)anImage active:(BOOL)isActive
{
    NSString *imageName;
    if (isActive) {
        imageName = [NSString stringWithFormat:@"tab-business-%@-active", anImage];
    } else {
        imageName = [NSString stringWithFormat:@"tab-business-%@", anImage];
    }
    
    [aButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

-(void)setButtonSelected:(UIButton*)aButton
{
    self.infoView.hidden = YES;
  //  self.hairfieView.hidden = YES;
    self.hairdresserView.hidden = YES;
 //   self.priceAndSaleView.hidden = YES;
    
    [self decorateButton:self.infoBttn withImage:@"infos" active:NO];
 //   [self decorateButton:self.hairfieBttn withImage:@"hairfies" active:NO];
    [self decorateButton:self.hairdresserBttn withImage:@"hairdressers" active:NO];
//    [self decorateButton:self.priceAndSaleBttn withImage:@"prices" active:NO];
    
    if (aButton == self.infoBttn) {
        [self decorateButton:self.infoBttn withImage:@"infos" active:YES];
        [self.containerView bringSubviewToFront:self.infoView];
        self.infoView.hidden = NO;
//    } else if (aButton == self.hairfieBttn) {
//        [self decorateButton:self.hairfieBttn withImage:@"hairfies" active:YES];
//        [self.containerView bringSubviewToFront:self.hairfieView];
//        self.hairfieView.hidden = NO;
    } else if (aButton == self.hairdresserBttn) {
        [self decorateButton:self.hairdresserBttn withImage:@"hairdressers" active:YES];
        [self.containerView bringSubviewToFront:self.hairdresserView];
        self.hairdresserView.hidden = NO;
    }
//     else if (aButton == self.priceAndSaleBttn) {
//        [self decorateButton:self.priceAndSaleBttn withImage:@"prices" active:YES];
//        [self.containerView bringSubviewToFront:self.priceAndSaleView];
//        self.priceAndSaleView.hidden = NO;
//    }
    
    for (UIButton *btn in @[self.infoBttn, /*self.hairfieBttn,*/ self.hairdresserBttn/*, self.priceAndSaleBttn*/]) {
        for (UIView *subView in btn.subviews) {
            if (subView.tag == 1) [subView removeFromSuperview];
        }
    }
    
    UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, aButton.frame.size.height, aButton.frame.size.width, 3)];
    bottomBorder.backgroundColor = [UIColor salonDetailTab];
    bottomBorder.tag = 1;
    [aButton addSubview:bottomBorder];
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
 //   _hairfieView.hidden = YES;
    _hairdresserView.hidden = YES;
 //   _priceAndSaleView.hidden = YES;
    [self setNormalStateColor:_infoBttn];
  //  [self setNormalStateColor:_hairfieBttn];
    [self setNormalStateColor:_hairdresserBttn];
  //  [self setNormalStateColor:_priceAndSaleBttn];
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
    
    UIAlertView *chooseCameraType = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Choose camera type", @"Login_Sign_Up", nil) message:NSLocalizedStringFromTable(@"Take picture or pick one from the saved photos", @"Login_Sign_Up", nil) delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:NSLocalizedStringFromTable(@"Camera", @"Login_Sign_Up", nil), NSLocalizedStringFromTable(@"Library", @"Login_Sign_Up", nil),nil];
    [chooseCameraType show];
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setDelegate:self];
    if (buttonIndex == 2) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
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
    navigationView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.78];
    
    
    UIImage *goBackImg = [UIImage imageNamed:@"arrow-nav.png"];
    UIButton *goBackButton = [UIButton
                              buttonWithType:UIButtonTypeCustom];
    [goBackButton setImage:goBackImg forState:UIControlStateNormal];
    [goBackButton addTarget:self action:@selector(cancelTakePicture) forControlEvents:UIControlEventTouchUpInside];
    [goBackButton setFrame:CGRectMake(0, 22, 60, 40)];
    [goBackButton setImageEdgeInsets:UIEdgeInsetsMake(10,10,10,30)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(92, 30, 136, 23)];
    titleLabel.text = NSLocalizedStringFromTable(@"Take Hairfie", @"Post_Hairfie", nil);
    titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor titleGrey];
    [navigationView addSubview:titleLabel];
    [navigationView addSubview:goBackButton];
    
    UIView *bottomNavigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 380, 320, self.view.frame.size.height - 380)];
    bottomNavigationView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.78];
    
    [overlayView addSubview:navigationView];
    [overlayView addSubview:bottomNavigationView];
    
    
    UIImage *takePictureImg = [UIImage imageNamed:@"take-picture-button.png"];
    
    UIButton *takePictureButton = [UIButton
                                   buttonWithType:UIButtonTypeCustom];
    [takePictureButton setImage:takePictureImg forState:UIControlStateNormal];
    [takePictureButton addTarget:self action:@selector(snapPicture) forControlEvents:UIControlEventTouchUpInside];
    [takePictureButton setFrame:CGRectMake(122, 380 + bottomNavigationView.frame.size.height/2 - 38, 77, 77)];
    
    takePictureButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    
  //  [self addLastPictureFromLibrary];
  //  [self addGoToLibraryButton:nil toView:overlayView];
    
    UIImage *switchCameraImg = [UIImage imageNamed:@"switch-camera-button.png"];
    
    UIButton *switchCameraButton = [UIButton
                                    buttonWithType:UIButtonTypeCustom];
    [switchCameraButton setImage:switchCameraImg forState:UIControlStateNormal];
    [switchCameraButton addTarget:self action:@selector(switchCamera) forControlEvents:UIControlEventTouchUpInside];
    [switchCameraButton setFrame:CGRectMake(248, 65, 52, 52)];
    [switchCameraButton setImageEdgeInsets:UIEdgeInsetsMake(10,10,10,10)];
    
    [overlayView addSubview:switchCameraButton];
    [overlayView addSubview:takePictureButton];
    //[self addFaceShapeToOverlay:overlayView];
    
    imagePicker.cameraOverlayView = overlayView;

}



-(void) uploadSalonImage:(UIImage *)image
{
    Picture *imagePost = [[Picture alloc] initWithImage:image andContainer:@"business-pictures"];
    
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error : %@", error.description);
    
    };

    void (^loadSuccessBlock)(void) = ^(void){
        if (_businessToManage != nil) {
            [_businessToManage.pictures addObject:imagePost];
            NSLog(@"test %@", imagePost.url);
        }
        [imagePicker dismissViewControllerAnimated:YES completion:nil];
    };
    
    [imagePost uploadWithSuccess:loadSuccessBlock failure:loadErrorBlock];
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
    UIImage *image;
    if([info valueForKey:UIImagePickerControllerEditedImage]) {
        image = [info valueForKey:UIImagePickerControllerEditedImage];
    } else {
        image = [info valueForKey:UIImagePickerControllerOriginalImage];
    }
    
    
    UIImage *resizedImage = [image resizedImageToFitInSize:CGSizeMake(640, 640) scaleIfSmaller:NO];
    [self uploadSalonImage:resizedImage];
    
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
        
    }
    if ([segue.identifier isEqualToString:@"claimAddress"])
    {
        FinalStepAddressViewController *claimAddress = [segue destinationViewController];
        if (_businessToManage != nil)
            claimAddress.address = _businessToManage.address;
    
    }
    
    if ([segue.identifier isEqualToString:@"claimTimetable"])
    {
        FinalStepTimetableViewController *claimTimetable = [segue destinationViewController];
        if (_businessToManage != nil)
            claimTimetable.timeTable = _businessToManage.timetable;
        
    }
    if ([segue.identifier isEqualToString:@"claimHairdresser"])
    {
        ClaimAddHairdresserViewController *claimHairdresser = [segue destinationViewController];
        if (_businessToManage != nil)
        {
            if  (_businessToManage.activeHairdressers != (id)[NSNull null])
            {
                
                claimHairdresser.claimedBusinessMembers = self.businessToManage.activeHairdressers;
                [_businessToManage.activeHairdressers removeObjectIdenticalTo:businessMemberForEditing];
            }
            else
    
                claimHairdresser.claimedBusinessMembers = [[NSMutableArray alloc] init];
        }
        
        if (_isEditingHairdresser == YES)
            claimHairdresser.businessMemberFromSegue = businessMemberForEditing;
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
        if (_isEditingService == YES)
            claimService.serviceFromSegue = serviceForEditing;
        _isEditingService = NO;
        claimService.serviceIndexFromSegue = serviceIndex;
        
    }
    
    if ([segue.identifier isEqualToString:@"toSalonDetail"]) {
        BusinessViewController *businessDetail = [segue destinationViewController];
        businessDetail.didClaim = YES;
        businessDetail.business = _businessToManage;
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
        
        BusinessMember *businessMember = [[BusinessMember alloc] init];
        
        
        if (_businessToManage != nil)
        {
            businessMember = [_businessToManage.activeHairdressers objectAtIndex:indexPath.row];
        }
        

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.fullName.text = [businessMember displayFullName];
        cell.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0);
        cell.tag = indexPath.row;
        return cell;
    }
    if (tableView == _serviceTableView)
    {
        static NSString *CellIdentifier = @"serviceCell";
        ClaimServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ClaimServiceTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        Service *service;
        if (_businessToManage != nil)
        {
           service =[_businessToManage.services objectAtIndex:indexPath.row];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.serviceName.text = service.label;
        cell.serviceAmount.text = [service.price formatted];
        cell.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0);
        cell.tag = indexPath.row;
        return cell;
    }
    
    return nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _hairdresserTableView)
    {
    if (_businessToManage.activeHairdressers != (id)[NSNull null])
        return [_businessToManage.activeHairdressers count];
    }
    if (tableView == _serviceTableView)
    {
        if (_businessToManage.services != (id)[NSNull null])
            return [_businessToManage.services count];
    }
    return 1;
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _hairdresserTableView)
    {
    if (_businessToManage != nil)
        businessMemberForEditing = [_businessToManage.activeHairdressers objectAtIndex:indexPath.row];
    _isEditingHairdresser = YES;
   
    [self performSegueWithIdentifier:@"claimHairdresser" sender:self];
    }
    if (tableView == _serviceTableView)
    {
        if (_businessToManage != nil)
            serviceForEditing = [_businessToManage.services objectAtIndex:indexPath.row];
        _isEditingService = YES;
        serviceIndex = indexPath.row;
        [self performSegueWithIdentifier:@"claimService" sender:self];
    }
}

-(void)clearHairdresser:(NSNotification*)notification
{
  
    HairdresserTableViewCell *cell = notification.object;
    BusinessMember *businessMember = [self.businessToManage.activeHairdressers objectAtIndex:cell.tag];
    businessMember.active = NO;
    [businessMember saveWithSuccess:^{
                                NSLog(@"Business member successfully saved");
                                [self.businessToManage.activeHairdressers removeObjectAtIndex:cell.tag];
                                [self.hairdresserTableView reloadData];
                            }
                            failure:^(NSError *error) {
                                NSLog(@"Failed to save business member: %@", error.localizedDescription);
                            }];
}

-(void)clearService:(NSNotification*)notification
{
    ClaimServiceTableViewCell *cell = notification.object;
    [_businessToManage.services removeObjectAtIndex:cell.tag];
    [_serviceTableView reloadData];
}

-(IBAction)claimThisBusiness:(id)sender
{
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        
        NSLog(@"Error : %@", error.description);
    };
    void (^loadSuccessBlock)(NSArray *) = ^(NSArray *results) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"currentUser" object:self];
        HairfieNotifications *notif = [HairfieNotifications new];
        [notif showNotificationWithMessage:NSLocalizedStringFromTable(@"Business updated", @"Claim", nil) ForDuration:2.5];
        [self performSegueWithIdentifier:@"toSalonDetail" sender:self];
    };

    [_businessToManage updateWithSuccess:loadSuccessBlock failure:loadErrorBlock];
}

@end
