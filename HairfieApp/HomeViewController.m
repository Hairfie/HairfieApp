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
#import "HairfieDetailViewController.h"
#import "UserRepository.h"
#import "LoginViewController.h"
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
    Hairfie *hairfieSelected;
    NSMutableArray *hairfies;
    NSInteger hairfieRow;
    UIAlertView *chooseCameraType;
    UIRefreshControl *refreshControl;
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
    BusinessSearch *businessSearch;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(segueToSearchResults:)
                                                 name:@"segueToSearchResults"
                                               object:nil];
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomePageViewController"];
    self.pageViewController.dataSource = self;
    self.filterSearchBttnTitle.text = NSLocalizedStringFromTable(@"Filter search", @"Feed", nil);
    
    pickerItemSelected = NSLocalizedStringFromTable(@"Book",@"Feed",nil);
    
    delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate startTrackingLocation:YES];

    self.navigationItem.title = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Home", @"Feed", nil)];
    
    refreshControl = [[UIRefreshControl alloc] init];
     self.takeHairfieBttn.hidden = YES;
    if([delegate.credentialStore isLoggedIn]) {
        if (nil != self.slidingViewController.panGesture) {
            // TODO: find why panGesture is nil when running tests
            [self.view addGestureRecognizer:self.slidingViewController.panGesture];
        }
    } else {
        NSLog(@"not logged");
        [self prepareUserNotLogged];
    }
    
    pickerItems = [[NSArray alloc] initWithObjects:NSLocalizedStringFromTable(@"Book",@"Feed",nil),NSLocalizedStringFromTable(@"Hairfies",@"Feed",nil), nil];
    
    
    
    // Init HomeContent
    
    HairfieContentViewController *hairfieVc = (HairfieContentViewController*)[self viewControllerAtIndex:1];
    hairfieContent = @[hairfieVc];
    CategoryContentViewController *categoryVc = (CategoryContentViewController*)[self viewControllerAtIndex:0];
    categoryContent = @[categoryVc];

    [self.pageViewController setViewControllers:categoryContent
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];

    // Change the size of page view controller
   // CGRect frame = CGRectMake(0, 147, self.view.frame.size.width, self.view.frame.size.height - 147);
    //self.pageViewController.view.frame = frame;
    self.pageViewController.doubleSided = YES;
    
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    [self.view bringSubviewToFront:self.takeHairfieBttn];
    [self.view sendSubviewToBack:self.pageViewController.view];
    
    //configure picker view
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.highlightedFont =  [UIFont fontWithName:@"SourceSansPro-Regular" size:17];
    self.pickerView.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:17];
    self.pickerView.highlightedTextColor = [UIColor whiteColor];
    self.pickerView.textColor = [UIColor whiteColor];
    self.pickerView.interitemSpacing = 75;
    self.pickerView.fisheyeFactor = 0.0001;
    [self.pickerView reloadData];

    UIView *pageViewControllerView = _pageViewController.view;
    [pageViewControllerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[pageViewControllerView]|"
                                                                      options:NSLayoutFormatDirectionLeadingToTrailing
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(pageViewControllerView)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-147-[pageViewControllerView]|"
                                                                      options:NSLayoutFormatDirectionLeadingToTrailing
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(pageViewControllerView)]];
    
}




-(void) viewDidAppear:(BOOL)animated {
}

-(void)viewDidLayoutSubviews
{
    [self drawTriangleInView];
}

-(void)drawTriangleInView
{
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
    
    NSDictionary *dic = notification.userInfo;
    businessSearch = [dic objectForKey:@"businessSearch"];
    [self performSegueWithIdentifier:@"showSearchResults" sender:self];
}

-(void)segueToHairfieDetail:(NSNotification*)notification {
    NSDictionary* userInfo = notification.userInfo;
    hairfieSelected = [userInfo objectForKey:@"hairfie"];
    [self performSegueWithIdentifier:@"hairfieDetail" sender:self];
}

-(IBAction)filterSearch:(id)sender {
    [self performSegueWithIdentifier:@"filterSearch" sender:self];
}

-(void)segueToSearchResults:(NSNotification*)notification {
    NSDictionary *dic = notification.userInfo;
    
    businessSearch = [dic objectForKey:@"businessSearch"];
   
    [self performSegueWithIdentifier:@"showSearchResults" sender:self];
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
         NSLog(@"view controllers %@", self.pageViewController.viewControllers);
        
    } else if ([pickerItemSelected isEqualToString:NSLocalizedStringFromTable(@"Hairfies",@"Feed",nil)]){
        self.takeHairfieBttn.hidden = NO;
        [self.pageViewController setViewControllers:hairfieContent direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        
        NSLog(@"vieW controllers %@", self.pageViewController.viewControllers);
    
    }
     NSLog(@"View controllers %@", self.pageViewController.viewControllers);
    
}

-(void)showNoNetwork:(NSNotification*)notification
{
    HairfieNotifications *notif;
    [notif showNotificationWithMessage:@"No active network" ForDuration:1];
}



-(void)viewWillAppear:(BOOL)animated
{
    if (_didClaim == YES) {
        [self showPopup];
    }
    [self addAllObservers];
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
       [self performSegueWithIdentifier:@"postHairfie" sender:self];
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


-(void)viewWillDisappear:(BOOL)animated {
    [self removeAllObservers];
    [self.pageViewController removeFromParentViewController];
}


-(void)willSearch:(NSNotification*)notification {
    [self performSegueWithIdentifier:@"searchFromFeed" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) prepareUserNotLogged {
    self.menuButton.hidden = YES;
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

-(void)addAllObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showNoNetwork:)
                                                 name:@"No Network" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doSearch:)
                                                 name:@"searchFromFeed" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(switchMenuItem:)
                                                 name:@"collectionChanged" object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(doSearch:)
//                                                 name:@"segueToSearchResults"
//                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(segueToHairfieDetail:)
                                                 name:@"hairfieSelected" object:nil];
}

-(void)removeAllObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:@"searchFromFeed" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:@"collectionChanged" object:nil];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                 name:@"segueToSearchResults" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:@"hairfieSelected" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kStatusBarTappedNotification object:nil];

}

- (void)dealloc {
    [self removeAllObservers];
}

#pragma mark - Navigation

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"filterSearch"])
    {
        SearchFilterViewController *searchFiltersVc = [segue destinationViewController];
        searchFiltersVc.isModifyingSearch = NO;
    }
    if ([segue.identifier isEqualToString:@"showSearchResults"])
    {
        AroundMeViewController *controller = [segue destinationViewController];
      
        controller.businessSearch = businessSearch;
    }
    if ([segue.identifier isEqualToString:@"hairfieDetail"])
    {
        HairfieDetailViewController *hairfieDetail = [segue destinationViewController];
        hairfieDetail.hairfie = hairfieSelected;
    }
}

@end
