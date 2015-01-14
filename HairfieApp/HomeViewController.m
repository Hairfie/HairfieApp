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
#import <Underscore.m/Underscore.h>


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
    NSArray *hairfieContent;
    NSArray *categoryContent;
    BOOL isSetup;
}
@end



@implementation HomeViewController

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        // Custom initialization
        NSLog(@"Was called...");
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomePageViewController"];
    self.pageViewController.dataSource = self;
   
    
    
    
    pickerItemSelected = NSLocalizedStringFromTable(@"Book",@"Feed",nil);
    
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
    
    pickerItems = [[NSArray alloc] initWithObjects:NSLocalizedStringFromTable(@"Book",@"Feed",nil),NSLocalizedStringFromTable(@"Hairfies",@"Feed",nil), nil];
    
    
   
    // Init HomeContent
    
    HairfieContentViewController *hairfieVc = (HairfieContentViewController*)[self viewControllerAtIndex:1];
    hairfieContent = @[hairfieVc];
    CategoryContentViewController *categoryVc = (CategoryContentViewController*)[self viewControllerAtIndex:0];
    categoryContent = @[categoryVc];
    [self.pageViewController setViewControllers:categoryContent direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    
    
    CGRect frame = CGRectMake(0, 147, self.view.frame.size.width, self.view.frame.size.height - 147);
    
    // Change the size of page view controller
    self.pageViewController.view.frame = frame;
    self.pageViewController.doubleSided = YES;
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    [self initPickerView];
    
    [self.view bringSubviewToFront:self.takeHairfieBttn];
    [self.view sendSubviewToBack:self.pageViewController.view];
    [self drawTriangleInView];
}


-(void)drawTriangleInView {
  
    
    CAShapeLayer *mask = [[CAShapeLayer alloc] init];
    mask.frame = self.pickerContainerView.bounds;
    mask.fillColor = [[UIColor blackColor] CGColor];
    
    CGFloat width = self.pickerContainerView.frame.size.width;
    CGFloat height = self.pickerContainerView.frame.size.height;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, nil, 0, 0);
    CGPathAddLineToPoint(path, nil, width, 0);
    CGPathAddLineToPoint(path, nil, width, height);
    CGPathAddLineToPoint(path, nil, (width/2) + 5, height);
    CGPathAddLineToPoint(path, nil, width/2, height - 5);
    CGPathAddLineToPoint(path, nil, (width/2) - 5, height);
    CGPathAddLineToPoint(path, nil, 0, height);
    CGPathAddLineToPoint(path, nil, 0, 0);
    CGPathCloseSubpath(path);
    
    mask.path = path;
    CGPathRelease(path);
    
    self.pickerContainerView.layer.mask = mask;


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
    if ([menuItem isEqualToString:NSLocalizedStringFromTable(@"Book",@"Feed",nil)]) {
        [self.pickerView scrollToItem:0 animated:YES];
        self.takeHairfieBttn.hidden = YES;
    } else {
        [self.pickerView scrollToItem:1 animated:YES];
        self.takeHairfieBttn.hidden = NO;
    }
}

// Page Controller Content View Functions

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([pickerItems count] == 0) || (index >= [pickerItems count])) {
        return nil;
    }
    if (index == 0) {
        CategoryContentViewController *categoryContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoryContentViewController"];
        categoryContentViewController.pageIndex = index;
        return categoryContentViewController;
    }
    else if (index == 1) {
        HairfieContentViewController *hairfieContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HairfieContentViewController"];
        hairfieContentViewController.pageIndex = index;
        hairfieContentViewController.menuItemSelected = pickerItemSelected;
        
        return hairfieContentViewController;
    }
    else
        return nil;
}



- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[HairfieContentViewController class]]) {
    NSUInteger index = ((CategoryContentViewController*)viewController).pageIndex;
   
    
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
    if ([viewController isKindOfClass:[CategoryContentViewController class]]) {
   
        
        NSUInteger index = ((HairfieContentViewController*)viewController).pageIndex;
    
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

// Init menu picker

-(void)initPickerView {
    self.pickerView = [[AKPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.highlightedFont =  [UIFont fontWithName:@"SourceSansPro-Regular" size:17];
    self.pickerView.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:17];
    self.pickerView.highlightedTextColor = [UIColor whiteColor];
    self.pickerView.textColor = [UIColor whiteColor];
    self.pickerView.interitemSpacing = 75;
    self.pickerView.fisheyeFactor = 0.0001;
    self.pickerView.tag = 0;
    [self.pickerView reloadData];
    if(!_.find(self.pickerContainerView.subviews, ^BOOL(UIView *subview) {
        return subview.tag == 0;
    })) {
        [self.pickerContainerView addSubview:self.pickerView];
    }
}

- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView {
    return [pickerItems count];
}

- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item {
    return pickerItems[item];
}


- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item {

    pickerItemSelected = [pickerItems objectAtIndex:item];
    
    if ([pickerItemSelected isEqualToString:NSLocalizedStringFromTable(@"Book",@"Feed",nil)]) {
        self.takeHairfieBttn.hidden = YES;
        [self.pageViewController setViewControllers:categoryContent direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];

    } else if ([pickerItemSelected isEqualToString:NSLocalizedStringFromTable(@"Hairfies",@"Feed",nil)]){
        self.takeHairfieBttn.hidden = NO;
        [self.pageViewController setViewControllers:hairfieContent direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
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
