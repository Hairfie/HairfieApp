//
//  HomeViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 28/07/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "HomeViewController.h"
#import "CustomCollectionViewCell.h"
#import "UIViewController+ECSlidingViewController.h"
#import "AroundMeViewController.h"
#import "AdvanceSearch.h"
#import "HairfieRequest.h"
#import "HairfieDetailViewController.h"


@interface HomeViewController ()
{
    AdvanceSearch *searchView;
    HairfieRequest *hairfieReq;
    NSArray *hairfies;
    NSInteger hairfieRow;
}
@end



@implementation HomeViewController


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NSString stringWithFormat:NSLocalizedString(@"Home", nil)];
     [_hairfieCollection registerNib:[UINib nibWithNibName:@"CustomCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"hairfieCell"];
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    hairfieReq = [[HairfieRequest alloc] init];
    _searchView.hidden = YES;
    [_searchView initView];
    [_searchView.searchAroundMeImage setTintColor:[UIColor lightBlueHairfie]];
    _searchView.searchByLocation.text = @"Around Me";
    //self.view.translatesAutoresizingMaskIntoConstraints = NO;
    //[self.view.translatesAutoresizingMaskIntoConstraints]
    [self getHairfies];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willSearch:) name:@"searchQuery" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"searchQuery" object:nil];
}


-(void)willSearch:(NSNotification*)notification
{
    [self performSegueWithIdentifier:@"searchFromFeed" sender:self];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //_advancedSearchView.hidden = NO;
   
    _searchView.hidden = NO;
    if ([_searchView.searchByLocation.text isEqualToString:@"Around Me"])
        [_searchView.searchAroundMeImage setTintColor:[UIColor lightBlueHairfie]];
    [_searchView.searchByName performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.0];

    [textField resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Collection View Datasource + Delegate

// header view size

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    return CGSizeMake(320, 200);
}

// header view data source

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
    
    return headerView;
}


- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [hairfies count];
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}


// 3
- (CustomCollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"hairfieCell";
    CustomCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    LBModel *model = (LBModel *)[hairfies objectAtIndex:indexPath.row];

    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCollectionViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    //cell.name.text = [model objectForKeyedSubscript:@"username"];
   
   // NSLog(@"userId : %@", [[hairfies objectAtIndex:0] valueForKey:@"userId"]);
    
    if (!hairfies) {
     cell.hairfieView.image = [UIImage imageNamed:@"hairfie.jpg"];
    }
    else {
        [cell.hairfieView sd_setImageWithURL:[[model objectForKeyedSubscript:@"pictureObj"] objectForKey:@"publicUrl"]
                            placeholderImage:[UIColor imageWithColor:[UIColor colorWithRed:234/255.0f green:236/255.0f blue:238/255.0f alpha:1]]];
        cell.hairfieView.contentMode = UIViewContentModeScaleAspectFill;
    }
    cell.layer.borderColor = [UIColor colorWithRed:234/255.0f green:236/255.0f blue:238/255.0f alpha:1].CGColor;
    cell.layer.borderWidth = 1.0f;
    return cell;
}


-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    hairfieRow = indexPath.row;
    [self performSegueWithIdentifier:@"hairfieDetail" sender:self];
    
}


-(IBAction)takePicture:(id)sender
{
    _imagePicker = [[UIImagePickerController alloc]init];
    [_imagePicker setDelegate:self];
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        _imagePicker.showsCameraControls = NO;
        _imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
        [self initOverlayView];
        
        [self presentViewController:_imagePicker animated:YES completion:nil];
    }
}


-(void) initOverlayView
{
    
    UIView *overlayView = [[UIView alloc] init];
    
    overlayView.frame =  _imagePicker.cameraOverlayView.frame;
    
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    navigationView.backgroundColor = [UIColor blackHairfie];
    
    
    UIImage *goBackImg = [UIImage imageNamed:@"arrow-nav.png"];
    UIButton *goBackButton = [UIButton
                              buttonWithType:UIButtonTypeCustom];
    [goBackButton setImage:goBackImg forState:UIControlStateNormal];
    [goBackButton addTarget:self action:@selector(cancelTakePicture) forControlEvents:UIControlEventTouchUpInside];
    [goBackButton setFrame:CGRectMake(10, 32, 20, 20)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(92, 30, 136, 23)];
    titleLabel.text = @"Post Hairfie";
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
    [takePictureButton setFrame:CGRectMake(122, 387, 77, 77)];
    
    takePictureButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    
    
    UIImage *goToLibraryImg = [UIImage imageNamed:@"leosquare.jpg"];
    
    UIButton *goToLibrary = [UIButton
                                   buttonWithType:UIButtonTypeCustom];
    [goToLibrary setImage:goToLibraryImg forState:UIControlStateNormal];
    goToLibrary.layer.cornerRadius = 5;
    goToLibrary.layer.masksToBounds = YES;
    goToLibrary.layer.borderWidth = 1;
    goToLibrary.layer.borderColor = [UIColor whiteColor].CGColor;
    [goToLibrary addTarget:self action:@selector(switchCameraSourceType) forControlEvents:UIControlEventTouchUpInside];
    [goToLibrary setFrame:CGRectMake(20, 420, 44, 44)];
    
    goToLibrary.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    
    UIImage *switchCameraImg = [UIImage imageNamed:@"switch-camera-button.png"];
    
    UIButton *switchCameraButton = [UIButton
                                    buttonWithType:UIButtonTypeCustom];
    [switchCameraButton setImage:switchCameraImg forState:UIControlStateNormal];
    [switchCameraButton addTarget:self action:@selector(switchCamera) forControlEvents:UIControlEventTouchUpInside];
    [switchCameraButton setFrame:CGRectMake(268, 75, 32, 32)];
    
    [overlayView addSubview:switchCameraButton];
    [overlayView addSubview:takePictureButton];
    [overlayView addSubview:goToLibrary];
    
    _imagePicker.cameraOverlayView = overlayView;
}


- (void)switchCamera
{
    if (_imagePicker.cameraDevice == UIImagePickerControllerCameraDeviceRear)
    {
        _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
    else
    {
        _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
}

-(void) switchCameraSourceType
{
    [_imagePicker dismissViewControllerAnimated:NO completion:nil];
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePicker.allowsEditing = YES;
    [self presentViewController:_imagePicker animated:YES completion:nil];
}

-(void)snapPicture
{
    [_imagePicker takePicture];
}

-(void) cancelTakePicture
{
    [_imagePicker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}



-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage : (UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
   
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_imagePicker dismissViewControllerAnimated:NO completion:nil];
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        _imagePicker.showsCameraControls = NO;
        _imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
        [self presentViewController:_imagePicker animated:YES completion:nil];
    }
}



-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"camera"])
    {
        UIImagePickerController *pickerController = [segue destinationViewController];
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerController.delegate = self;
    }
    if ([segue.identifier isEqualToString:@"searchFromFeed"])
    {
        AroundMeViewController *aroundMe = [segue destinationViewController];
        aroundMe.searchInProgressFromSegue = _searchView.searchRequest;
        aroundMe.queryNameInProgressFromSegue = _searchView.searchByName.text;
        aroundMe.queryLocationInProgressFromSegue = _searchView.searchByLocation.text;
        aroundMe.gpsStringFromSegue = _searchView.gpsString;
        aroundMe.locationFromSegue = _searchView.locationSearch;
    }
    if ([segue.identifier isEqualToString:@"hairfieDetail"])
    {
        HairfieDetailViewController *hairfieDetail = [segue destinationViewController];
        hairfieDetail.currentHairfie = [hairfies objectAtIndex:hairfieRow];
    }

}


-(void)getHairfies
{
        void (^loadErrorBlock)(NSError *) = ^(NSError *error){
            NSLog(@"Error on load %@", error.description);
        };
       void (^loadSuccessBlock)(NSArray *) = ^(NSArray *model){
           hairfies = model;
           [_hairfieCollection reloadData];
        };
    [hairfieReq getHairfies:loadSuccessBlock failure:loadErrorBlock];
}


// 4
/*- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/


/*
- (void)applicationFinishedRestoringState
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Call whatever function you need to visually restore
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
