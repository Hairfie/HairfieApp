//
//  FinalStepViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 17/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "FinalStepViewController.h"
#import "FinalStepClaimInfoViewController.h"
#import "HairdresserTableViewCell.h"
#import "ClaimServiceTableViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "Address.h"
#import "BusinessMember.h"
#import "Picture.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ClaimAddHairdresserViewController.h"
#import "ClaimAddServicesViewController.h"
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
    BOOL uploadInProgress;
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


    self.addServicesLbl.text = NSLocalizedStringFromTable(@"Add service", @"Claim", nil);
    [self setupGallery:nil];
  
    [self.view bringSubviewToFront:self.topBarView];
    [self setButtonSelected:_infoBttn];
    pictureForGallery = [[NSMutableArray alloc] init];

    if(![_businessToManage.timetable isKindOfClass:[Timetable class]]) {
       _businessToManage.timetable = [[Timetable alloc] initEmpty];
    }
    
    _validateBttn.layer.cornerRadius = 5;
    _validateBttn.layer.masksToBounds = YES;
}

-(void)viewDidLayoutSubviews
{
    if (_businessToManage != nil)
        [self setupGallery:_businessToManage.pictures];
    [self setupTabBar];
}

-(void)setupTabBar {
    self.firstSeparatorLeading.constant = self.view.frame.size.width / 3;
    self.secondSeparatorLeading.constant = self.view.frame.size.width / 3;
}

-(IBAction)changePage:(id)sender {
    
    UIPageControl *pager = sender;
    CGPoint offset = CGPointMake(pager.currentPage * _imageSliderView.frame.size.width, 0);
    [_imageSliderView setContentOffset:offset animated:YES];
}


-(void) scrollViewDidScroll:(UIScrollView *)scrollview
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
        frame.size = CGSizeMake(self.view.frame.size.width, _imageSliderView.frame.size.height);
        UIView *bgView = [[UIView alloc] initWithFrame:frame];
        bgView.backgroundColor = [UIColor lightGreyHairfie];
        [_imageSliderView addSubview:bgView];
        UIView *borderBttn =[[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 55, 35, 110, 110)];
        borderBttn.backgroundColor = [UIColor whiteColor];
        borderBttn.alpha = 0.2;
        borderBttn.layer.cornerRadius = borderBttn.frame.size.height / 2;
        borderBttn.clipsToBounds = YES;
        
        UIButton *addPictureBttn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 50, 40, 100, 100)];
        addPictureBttn.layer.cornerRadius = addPictureBttn.frame.size.height / 2;
        addPictureBttn.clipsToBounds = YES;
        addPictureBttn.backgroundColor = [UIColor colorWithRed:250/255.0f green:66/255.0f blue:77/255.0f alpha:1];
        [addPictureBttn addTarget:self
                           action:@selector(validateAddPicture)
                 forControlEvents:UIControlEventTouchUpInside];
        
        [_imageSliderView addSubview:borderBttn];
        [_imageSliderView addSubview:addPictureBttn];
    
        UILabel *addPictureLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 30, 60, 60, 60)];
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
            frame.size = CGSizeMake(self.view.frame.size.width, _imageSliderView.frame.size.height);
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
            [imageView sd_setImageWithURL:pic.url
                                placeholderImage:[UIColor imageWithColor:[UIColor lightGreyHairfie]]];
            
            imageView.contentMode = UIViewContentModeScaleToFill;
            [_imageSliderView addSubview:imageView];
        }
    }
    _imageSliderView.pagingEnabled = YES;
    _imageSliderView.contentSize = CGSizeMake(self.view.frame.size.width + self.view.frame.size.width *
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
        [self viewDidLayoutSubviews];
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
        NSLog(@"services %@", self.businessToManage.services);
        
        
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


-(void)decorateImage:(UIImageView *)anImageView withImage:(NSString *)anImage active:(BOOL)isActive
{
    NSString *imageName;
    if (isActive) {
        imageName = [NSString stringWithFormat:@"tab-business-%@-active", anImage];
    } else {
        imageName = [NSString stringWithFormat:@"tab-business-%@", anImage];
    }
    anImageView.image = [UIImage imageNamed:imageName];
}



-(void)setButtonSelected:(UIButton*)aButton
{
    self.infoView.hidden = YES;
    self.hairdresserView.hidden = YES;
    
    [self decorateImage:self.infoBttnImage withImage:@"infos" active:NO];
    [self decorateImage:self.hairdresserBttnImage withImage:@"hairdressers" active:NO];

    if (aButton == self.infoBttn) {
        [self decorateImage:self.infoBttnImage withImage:@"infos" active:YES];
        [self.containerView bringSubviewToFront:self.infoView];
        self.infoView.hidden = NO;
    } else if (aButton == self.hairdresserBttn) {
        [self decorateImage:self.hairdresserBttnImage withImage:@"hairdressers" active:YES];
        [self.containerView bringSubviewToFront:self.hairdresserView];
        self.hairdresserView.hidden = NO;
    } else if (aButton == self.hairdresserBttn) {
    
        [self decorateImage:self.servicesBttnImage withImage:@"services" active:YES];
        [self.containerView bringSubviewToFront:self.servicesView];
        self.servicesView.hidden = NO;
    }

    for (UIButton *btn in @[self.infoBttn, self.hairdresserBttn, self.servicesBttn]) {
        for (UIView *subView in btn.subviews) {
            if (subView.tag == 1) [subView removeFromSuperview];
        }
    }
    
    UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, aButton.frame.size.height, self.view.frame.size.width / 3, 3)];
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
    [self performSegueWithIdentifier:@"modifyClaimPhone" sender:self];
}

-(IBAction)modifyName:(id)sender
{
    [self performSegueWithIdentifier:@"modifyClaimSalon" sender:self];
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

-(void)validateAddPicture
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @"Salon_Detail", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedStringFromTable(@"Add Pictures", @"Claim", nil),nil];
    
    
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex) [self checkIfCameraDisabled];
    if (1 == buttonIndex) return; // it's the cancel button
}

-(void)checkIfCameraDisabled
{
    __block BOOL isChecked = NO;
    ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
    
    [lib enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        NSLog(stop ? @"Yes" : @"No");
        if (isChecked == NO) {
            [ImageSetPicker setup:self];
            
            isChecked = YES;
        }
    } failureBlock:^(NSError *error) {
        if (error.code == ALAssetsLibraryAccessUserDeniedError) {
            NSLog(@"user denied access : %@",error.description);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Warning",@"Claim", nil) message:NSLocalizedStringFromTable(@"authorized access to camera", @"Post_Hairfie", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alertView show];
        }else{
            NSLog(@"Other error code: %zi",error.code);
        }
    }];
}

-(NSInteger)imageSetPickerMinimumImageCount:(ImageSetPicker *)imageSetPicker
{
    return 1;
}

-(NSInteger)imageSetPickerMaximumImageCount:(ImageSetPicker *)imageSetPicker
{
    return 1;
}

-(void)imageSetPickerDidCancel:(ImageSetPicker *)imageSetPicker
{
    [ImageSetPicker remove:imageSetPicker];
}

-(void)imageSetPicker:(ImageSetPicker *)imageSetPicker didReturnWithImages:(NSArray *)images
{
    [ImageSetPicker remove:imageSetPicker];
    
    [self uploadSalonImage:images[0]];

}

-(void) uploadSalonImage:(UIImage *)image
{
    Picture *imagePost = [[Picture alloc] initWithImage:image andContainer:@"business-pictures"];
    
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error : %@", error.description);
        uploadInProgress = NO;
    };

    void (^loadSuccessBlock)(void) = ^(void){
        
        if (_businessToManage != nil) {
            [_businessToManage.pictures addObject:imagePost];
            [self setupGallery:_businessToManage.pictures];
        }
       // [imagePicker dismissViewControllerAnimated:YES completion:nil];
        uploadInProgress = NO;

    };
    
    [imagePost uploadWithSuccess:loadSuccessBlock failure:loadErrorBlock];
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"modifyClaimSalon"])
    {
        
        FinalStepClaimInfoViewController *claimInfo  = [segue destinationViewController];
        claimInfo.isBusinessInfo = YES;
        claimInfo.isFinalStep = YES;
        claimInfo.isExisting = YES;
        claimInfo.isSalon = YES;
        claimInfo.headerTitle = NSLocalizedStringFromTable(@"Salon's name", @"Claim", nil);
        claimInfo.textFieldPlaceHolder = NSLocalizedStringFromTable(@"Salon's name", @"Claim", nil);
        if (_businessToManage != nil)
            claimInfo.textFieldFromSegue = _businessToManage.name;

        
    }
    
    if ([segue.identifier isEqualToString:@"modifyClaimPhone"])
    {
        
        
        FinalStepClaimInfoViewController *claimInfo  = [segue destinationViewController];
        claimInfo.isBusinessInfo = YES;
        claimInfo.isFinalStep = YES;
        claimInfo.isExisting = YES;
        claimInfo.isSalon = NO;
        claimInfo.headerTitle = NSLocalizedStringFromTable(@"Phone number", @"Claim", nil);
        claimInfo.textFieldPlaceHolder = NSLocalizedStringFromTable(@"Phone number", @"Claim", nil);
        if (_businessToManage != nil)
            claimInfo.textFieldFromSegue = _businessToManage.phoneNumber;
        
    }
    if ([segue.identifier isEqualToString:@"claimAddress"])
    {
        FinalStepClaimInfoViewController *claimInfo  = [segue destinationViewController];
        claimInfo.isAddress = YES;
        claimInfo.headerTitle = NSLocalizedStringFromTable(@"Address", @"Claim", nil);
        if (_businessToManage != nil)
            claimInfo.address = _businessToManage.address;
    
    }
    
    if ([segue.identifier isEqualToString:@"claimTimetable"])
    {
        FinalStepClaimInfoViewController *claimInfo  = [segue destinationViewController];
        claimInfo.isTimetable = YES;
        claimInfo.headerTitle = NSLocalizedStringFromTable(@"Modify Timetable", @"Claim", nil);
        if (_businessToManage != nil)
            claimInfo.timeTable = _businessToManage.timetable;
    }
    if ([segue.identifier isEqualToString:@"claimHairdresser"])
    {
        ClaimAddHairdresserViewController *claimHairdresser = [segue destinationViewController];
        if (_businessToManage != nil)
        {
            
            if (_isEditingHairdresser == YES) {
                claimHairdresser.businessMemberFromSegue = businessMemberForEditing;
                _isEditingHairdresser = NO;
            }
            if  (_businessToManage.activeHairdressers != (id)[NSNull null])
            {
                
                claimHairdresser.claimedBusinessMembers = self.businessToManage.activeHairdressers;
            }
            else
    
                claimHairdresser.claimedBusinessMembers = [[NSMutableArray alloc] init];
        }
       
    }
    if ([segue.identifier isEqualToString:@"claimService"])
    {
        
        ClaimAddServicesViewController *claimService = [segue destinationViewController];
        
        if (_businessToManage != nil)
        {
        if (_businessToManage.services != (id)[NSNull null])
            claimService.serviceClaimed = _businessToManage.services;
        else
            claimService.serviceClaimed = [[NSMutableArray alloc] init];
        }
        if (_isEditingService == YES) {
            claimService.serviceFromSegue = serviceForEditing;
          _isEditingService = NO;
        }
        else {
            claimService.serviceFromSegue = nil;
        }
       
        claimService.serviceIndexFromSegue = serviceIndex;
        claimService.businessId = self.businessToManage.id;
        
        
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
        NSLog(@"service %@", [service toDictionary]);
        
        NSLog(@"version %@", [NSString stringWithFormat:@"Version %@",  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]);
        
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
        if (_businessToManage != nil) {
            businessMemberForEditing = [_businessToManage.activeHairdressers objectAtIndex:indexPath.row];
        }
        _isEditingHairdresser = YES;
        [self performSegueWithIdentifier:@"claimHairdresser" sender:self];
    }
    if (tableView == _serviceTableView)
    {
        if (_businessToManage != nil) {
            serviceForEditing = [_businessToManage.services objectAtIndex:indexPath.row];
        }
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
    [businessMember saveWithSuccess:^(NSDictionary *result){
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
    
    Service *serviceToDelete = [_businessToManage.services objectAtIndex:cell.tag];
    
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error : %@", error.description);
        
    };
    void (^loadSuccessBlock)() = ^(){
        [_businessToManage.services removeObjectAtIndex:cell.tag];
        [_serviceTableView reloadData];
    };
    [Service deleteService:serviceToDelete.id success:loadSuccessBlock failure:loadErrorBlock];
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
