//
//  HomeViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 28/07/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "HomeViewController.h"
#import "CustomCollectionViewCell.h"
#import "LoadingCollectionViewCell.h"
#import "UIViewController+ECSlidingViewController.h"
#import "AroundMeViewController.h"
#import "AdvanceSearch.h"
#import "HairfieDetailViewController.h"
#import "ApplyFiltersViewController.h"
#import "UserRepository.h"
#import "LoginViewController.h"
#import "CameraOverlayViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "HairfieNotifications.h"
#import "HairfieContentViewController.h"
#import "CategoryContentViewController.h"
#import "CategoriesCollectionViewCell.h"

#define CUSTOM_CELL_IDENTIFIER @"hairfieCell"
#define LOADING_CELL_IDENTIFIER @"LoadingItemCell"
#define CATEGORY_CELL_IDENTIFIER @"categoryCell"


@interface HomeViewController ()
{
    AppDelegate *delegate;
    AdvanceSearch *searchView;
    Hairfie *hairfieSelected;
    NSMutableArray *hairfies;
    NSInteger hairfieRow;
    UIAlertView *chooseCameraType;
    UIRefreshControl *refreshControl;
    UIGestureRecognizer *dismiss;
    NSNumber *currentPage;
    BOOL endOfScroll;
    NSArray *pickerItems;
    BOOL shouldDisplayHairfies;
    NSArray *categoriesNames;
    NSArray *categoriesImages;
    NSString *pickerItemSelected;
}
@end



@implementation HomeViewController

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Init page controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomePageViewController"];
    self.pageViewController.dataSource = self;
   
    
    
    
    pickerItemSelected = @"Hairfies";
    
    delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate startTrackingLocation:YES];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNoNetwork:) name:@"No Network" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doSearch:) name:@"searchFromFeed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(segueToHairfieDetail:) name:@"hairfieSelected" object:nil];
    
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchMenuItem:) name:@"collectionChanged" object:nil];
    
    self.navigationItem.title = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Home", @"Feed", nil)];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(getHairfiesFromRefresh:)
             forControlEvents:UIControlEventValueChanged];
    

     dismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    if([delegate.credentialStore isLoggedIn]) {
        [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    } else {
        NSLog(@"not logged");
        [self prepareUserNotLogged];
    }
    [_topBarView addBottomBorderWithHeight:1.0 andColor:[UIColor lightGrey]];
    
    pickerItems = [[NSArray alloc] initWithObjects:@"Hairfies", @"Réserver", nil];
    
    
   
    // Init HomeContent
    
    HairfieContentViewController *hairfieContent = (HairfieContentViewController*)[self viewControllerAtIndex:0];
    NSArray *viewControllers = @[hairfieContent];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    
    
    CGRect frame = CGRectMake(0, 182, self.view.frame.size.width, self.view.frame.size.height);

    // Change the size of page view controller
    self.pageViewController.view.frame = frame;
    self.pageViewController.doubleSided = YES;
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    [self initPickerView];
    [self.pickerContainerView addSubview:self.pickerView];
    [self.pickerView reloadData];
}

-(void)doSearch:(NSNotification*)notification {
     [self performSegueWithIdentifier:@"searchFromFeed" sender:self];
}

-(void)segueToHairfieDetail:(NSNotification*)notification {
    NSDictionary* userInfo = notification.userInfo;
    hairfieSelected = [userInfo objectForKey:@"hairfie"];
    [self performSegueWithIdentifier:@"hairfieDetail" sender:self];
}

-(void)switchMenuItem:(NSNotification*)notification{
    NSDictionary* userInfo = notification.userInfo;
    NSString *menuItem = [userInfo objectForKey:@"menuItem"];
    if ([menuItem isEqualToString:@"Hairfies"])
        [self.pickerView scrollToItem:0 animated:YES];
    else
        [self.pickerView scrollToItem:1 animated:YES];
}

// Page Controller Content View Functions

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([pickerItems count] == 0) || (index >= [pickerItems count])) {
        return nil;
    }
    
    if (index == 0) {
    HairfieContentViewController *hairfieContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HairfieContentViewController"];
    hairfieContentViewController.pageIndex = index;
    hairfieContentViewController.menuItemSelected = pickerItemSelected;
    
    return hairfieContentViewController;
    }
    else if (index == 1) {
        CategoryContentViewController *categoryContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoryContentViewController"];
         categoryContentViewController.pageIndex = index;
        return categoryContentViewController;
    }
    else
        return nil;
}



- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[CategoryContentViewController class]]) {
    NSUInteger index = ((HairfieContentViewController*)viewController).pageIndex;
   
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    pickerItemSelected = [pickerItems objectAtIndex:index];
    return [self viewControllerAtIndex:index];
    }
    else
        return nil;
}



- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[HairfieContentViewController class]]) {
   
        
        NSUInteger index = ((CategoryContentViewController*)viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
 
    index++;
    if (index == [pickerItems count]) {
        return nil;
    }
    pickerItemSelected = [pickerItems objectAtIndex:index];
    return [self viewControllerAtIndex:1];
    }
    else
        return nil;
}


- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [pickerItems count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

// Init menu picker

-(void)initPickerView {
    self.pickerView = [[AKPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.highlightedFont =  [UIFont fontWithName:@"SourceSansPro-Regular" size:17];
    self.pickerView.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:17];
    self.pickerView.highlightedTextColor = [UIColor whiteColor];
    self.pickerView.textColor = [UIColor whiteColor];
    self.pickerView.interitemSpacing = 75;
    self.pickerView.fisheyeFactor = 0.0001;
}

- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView {
    return [pickerItems count];
}

- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item {
    return pickerItems[item];
}


- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item {

    pickerItemSelected = [pickerItems objectAtIndex:item];
    
    if ([pickerItemSelected isEqualToString:@"Hairfies"]) {
        HairfieContentViewController *hairfieContent = (HairfieContentViewController*)[self viewControllerAtIndex:0];
        NSArray *viewControllers = @[hairfieContent];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
        
        NSLog(@"switch to page Hairfies");
    } else if ([pickerItemSelected isEqualToString:@"Réserver"]){
        CategoryContentViewController *categoryContent =(CategoryContentViewController*)[self viewControllerAtIndex:1];
        NSArray *viewControllers = @[categoryContent];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        NSLog(@"switch to page Reserver");
    }
}

-(void)showNoNetwork:(NSNotification*)notification
{
    HairfieNotifications *notif;
    [notif showNotificationWithMessage:@"No active network" ForDuration:1];
}


-(void) hideKeyboard
{
    [self.view removeGestureRecognizer:dismiss];
}


-(void)viewWillAppear:(BOOL)animated
{
    if (_didClaim == YES)
    {
        [self showPopup];
    }
    [ARAnalytics pageView:@"AR - Feed"];
}


-(void)showPopup {
    _popViewController = [[PopUpViewController alloc] initWithNibName:@"PopUpViewController" bundle:nil];
    [_popViewController showInView:self.view withTitle:NSLocalizedStringFromTable(@"You just claimed your business!", @"Claim", nil) withMessage:NSLocalizedStringFromTable(@"If you want to modify it, go into the menu and select your business", @"Claim", nil) withButton:NSLocalizedStringFromTable(@"Ok", @"Claim", nil) animated:YES];
}


-(IBAction)takeHairfie:(id)sender
{
    [self checkIfCameraDisabled];
}

-(void)checkIfCameraDisabled
{
    __block BOOL isChecked = NO;
    ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
    [lib enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (isChecked == NO) {
       [self performSegueWithIdentifier:@"cameraOverlay" sender:self];
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


-(void)viewWillDisappear:(BOOL)animated
{
    [self.view removeGestureRecognizer:dismiss];
}


-(void)willSearch:(NSNotification*)notification
{
    [self performSegueWithIdentifier:@"searchFromFeed" sender:self];
    [self.view removeGestureRecognizer:dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //NSArray *indexPaths = [_hairfieCollection indexPathsForVisibleItems];
    //NSLog(@"indexPaths scroll %@", indexPaths);
}


-(void) prepareUserNotLogged {
    [_menuButton setHidden:YES];
    
    UIImage *loginButtonImg = [UIImage imageNamed:@"login-user.png"];
    loginButtonImg = [loginButtonImg imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(0, 20, 40, 40)];
    [loginButton setImageEdgeInsets:UIEdgeInsetsMake(10,12,8,12)];
    [loginButton setImage:loginButtonImg forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(backToLogin) forControlEvents:UIControlEventTouchUpInside];
    loginButton.imageView.tintColor = [UIColor pinkBtnHairfie];
    [_topBarView addSubview:loginButton];
}

-(void)backToLogin {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"backToLogin" object:self];
}


#pragma mark - Navigation

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"searchFromFeed"])
    {
      //  AroundMeViewController *controller = [segue destinationViewController];
      
    }
    if ([segue.identifier isEqualToString:@"hairfieDetail"])
    {
        HairfieDetailViewController *hairfieDetail = [segue destinationViewController];
        hairfieDetail.hairfie = hairfieSelected;

    }
    if ([segue.identifier isEqualToString:@"cameraOverlay"])
    {
        CameraOverlayViewController *cameraOverlay= [segue destinationViewController];
    
        cameraOverlay.isHairfie = YES;
    }
    
}

@end
