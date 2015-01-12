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
#import "CategoriesCollectionViewCell.h"
#import "HomeContentViewController.h"

#define CUSTOM_CELL_IDENTIFIER @"hairfieCell"
#define LOADING_CELL_IDENTIFIER @"LoadingItemCell"
#define CATEGORY_CELL_IDENTIFIER @"categoryCell"


@interface HomeViewController ()
{
    AppDelegate *delegate;
    AdvanceSearch *searchView;
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
    
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchMenuItem:) name:@"collectionChanged" object:nil];
    
    self.navigationItem.title = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Home", @"Feed", nil)];
    [_hairfieCollection registerNib:[UINib nibWithNibName:@"CustomCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CUSTOM_CELL_IDENTIFIER];
    [_hairfieCollection registerNib:[UINib nibWithNibName:@"CategoriesCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CATEGORY_CELL_IDENTIFIER];
    [_hairfieCollection registerNib:[UINib nibWithNibName:@"LoadingCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:LOADING_CELL_IDENTIFIER];
   
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(getHairfiesFromRefresh:)
             forControlEvents:UIControlEventValueChanged];
    [_hairfieCollection addSubview:refreshControl];
    currentPage = @(0);
    hairfies = [[NSMutableArray alloc] init];
    endOfScroll = NO;
    [self getHairfies:nil];
     dismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    if([delegate.credentialStore isLoggedIn]) {
        [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    } else {
        NSLog(@"not logged");
        [self prepareUserNotLogged];
    }
    [_topBarView addBottomBorderWithHeight:1.0 andColor:[UIColor lightGrey]];
    categoriesNames = [[NSArray alloc] initWithObjects:@"FEMME",@"HOMME",@"BARBIER",@"MARIAGE",@"COLORATION", nil];
    
    categoriesImages = [[NSArray alloc] initWithObjects:@"woman-category.png",@"man-category.png",@"barber-category.png",@"marriage-category.png",@"color-category.png", nil];
    [self initPickerView];
    
    // Init HomeContent
    
    HomeContentViewController *homeContent = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = @[homeContent];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    
    
    CGRect frame = CGRectMake(0, 182, self.view.frame.size.width, self.view.frame.size.height);
    
    // Change the size of page view controller
    self.pageViewController.view.frame = frame;
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}


-(void)switchMenuItem:(NSNotification*)notification{
    NSDictionary* userInfo = notification.userInfo;
    NSString *menuItem = [userInfo objectForKey:@"menuItem"];
    if ([menuItem isEqualToString:@"Hairfies"])
        [self.pickerView selectItem:0 animated:YES];
    else
       [self.pickerView selectItem:1 animated:YES];
}

// Page Controller Content View Functions

- (HomeContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
 
    if (([pickerItems count] == 0) || (index >= [pickerItems count])) {
        return nil;
    }
    
    HomeContentViewController *homeContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeContentViewController"];
    homeContentViewController.pageIndex = index;
    homeContentViewController.menuItemSelected = pickerItemSelected;
    
    return homeContentViewController;
}



- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((HomeContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    [self.pickerView scrollToItem:index animated:YES];
    pickerItemSelected = [pickerItems objectAtIndex:index];
    return [self viewControllerAtIndex:index];
}



- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((HomeContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    [self.pickerView scrollToItem:index animated:YES];
    index++;
    if (index == [pickerItems count]) {
        return nil;
    }
 pickerItemSelected = [pickerItems objectAtIndex:index];
    return [self viewControllerAtIndex:index];
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
    self.pickerView.font = [UIFont fontWithName:@"SourceSansPro-Light" size:17];
    self.pickerView.highlightedTextColor = [UIColor whiteColor];
    self.pickerView.textColor = [UIColor whiteColor];
    self.pickerView.interitemSpacing = 75;
    self.pickerView.fisheyeFactor = 0.0001;
    pickerItems = [[NSArray alloc] initWithObjects:@"Hairfies", @"Réserver", nil];
    
    [self.pickerContainerView addSubview:self.pickerView];
}

- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView {
    return 2;
}

- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item {
    return pickerItems[item];
}

- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item {
    
    pickerItemSelected = [pickerItems objectAtIndex:item];
    
    if ([pickerItemSelected isEqualToString:@"Hairfies"]) {
        self.takeHairfieBttn.hidden = NO;
    } else if ([pickerItemSelected isEqualToString:@"Réserver"]){
       
        self.takeHairfieBttn.hidden = YES;

    }
    [UIView transitionWithView: self.hairfieCollection
                      duration: 0.5f
                       options: UIViewAnimationOptionTransitionCrossDissolve
                    animations: ^(void)
     {
         [self.hairfieCollection reloadData];
     }
                    completion: ^(BOOL isFinished)
     {
         /* TODO: Whatever you want here */
     }];

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
    [self getHairfies:nil];
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


// Collection View Datasource + Delegate

// header view size

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([pickerItemSelected isEqualToString:@"Hairfies"]) {
    if (indexPath.row < [hairfies count]) {
        return CGSizeMake((collectionView.frame.size.width - 30) / 2, 210);
    } else {
        return CGSizeMake(collectionView.frame.size.width, 58);
    }
    }
    else  if ([pickerItemSelected isEqualToString:@"Réserver"]){
        return CGSizeMake(collectionView.frame.size.width - 30, 100);
    }
    else
        return CGSizeMake(100, 100);
        
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    if ([pickerItemSelected isEqualToString:@"Hairfies"])
        return [hairfies count] + 1;
    else  if ([pickerItemSelected isEqualToString:@"Réserver"])
        return [categoriesNames count];
    else
        return 0;
    
    
}

// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 2;
}


// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([pickerItemSelected isEqualToString:@"Hairfies"]) {
    if (indexPath.row < [hairfies count]) {

        if(indexPath.row == ([hairfies count] - HAIRFIES_PAGE_SIZE + 1)){
            [self fetchMoreHairfies];
        }

        return [self hairfieCellForIndexPath:indexPath];
    } else {
        return [self loadingCellForIndexPath:indexPath];
    }
    }
    else  if ([pickerItemSelected isEqualToString:@"Réserver"]) {
        return [self categoryCellForIndexPath:indexPath];
    }
    else
        return nil;
}

- (UICollectionViewCell *)categoryCellForIndexPath:(NSIndexPath *)indexPath{

    CategoriesCollectionViewCell *cell = [_hairfieCollection dequeueReusableCellWithReuseIdentifier:CATEGORY_CELL_IDENTIFIER forIndexPath:indexPath];

    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CategoriesCollectionViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    [cell setupCellWithName:[categoriesNames objectAtIndex:indexPath.item] andImage:[UIImage imageNamed:[categoriesImages objectAtIndex:indexPath.item]]];
    
    return cell;
}


- (UICollectionViewCell *)hairfieCellForIndexPath:(NSIndexPath *)indexPath{
    CustomCollectionViewCell *cell = [_hairfieCollection dequeueReusableCellWithReuseIdentifier:CUSTOM_CELL_IDENTIFIER forIndexPath:indexPath];
    Hairfie *hairfie = (Hairfie *)[hairfies objectAtIndex:indexPath.row];

    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCollectionViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    if (!hairfies) {
        cell.hairfieView.image = [UIImage imageNamed:@"hairfie.jpg"];
    }
    else {
        [cell setHairfie:hairfie];
    }

    return cell;
}

- (UICollectionViewCell *)loadingCellForIndexPath:(NSIndexPath *)indexPath {
    LoadingCollectionViewCell *cell = [_hairfieCollection dequeueReusableCellWithReuseIdentifier:LOADING_CELL_IDENTIFIER forIndexPath:indexPath];

    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LoadingCollectionViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    if(endOfScroll) {
        [cell showEndOfScroll];
    }

    return cell;
}


-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([pickerItemSelected isEqualToString:@"Hairfies"]) {
        hairfieRow = indexPath.row;
        NSLog(@"select hairfie");
        [self performSegueWithIdentifier:@"hairfieDetail" sender:self];
    } else  if ([pickerItemSelected isEqualToString:@"Réserver"]) {
        
        [self performSegueWithIdentifier:@"searchFromFeed" sender:self];
        
    }
    else
        NSLog(@"nuff");

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //NSArray *indexPaths = [_hairfieCollection indexPathsForVisibleItems];
    //NSLog(@"indexPaths scroll %@", indexPaths);
}


-(void)getHairfies:(NSNumber *)page
{
    if(page == nil) {
        page = @(0);
    }
    NSNumber *offset = @([page integerValue] * HAIRFIES_PAGE_SIZE);

    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error on load %@", error.description);
        [refreshControl endRefreshing];
    };
    void (^loadSuccessBlock)(NSArray *) = ^(NSArray *models){
        if([models count] < HAIRFIES_PAGE_SIZE) endOfScroll = YES;
        for (int i = 0; i < models.count; i++) {
            NSNumber *dynamicIndex = @(i + [offset integerValue]);
            if([dynamicIndex integerValue] < [hairfies count]) {
                [hairfies replaceObjectAtIndex:[dynamicIndex integerValue] withObject:models[i]];
            } else {
                [hairfies addObject:models[i]];
            }
        }
        [self customReloadData];
    };
    NSLog(@"Get Hairfies for page : %@", page);

    if(!endOfScroll) {
        [Hairfie listLatestPerPage:page
                           success:loadSuccessBlock
                           failure:loadErrorBlock];
    }
}

-(void)getHairfiesFromRefresh:(UIRefreshControl *)refresh {
    [self getHairfies:nil];
}

- (void)customReloadData
{
    [_hairfieCollection reloadData];
    if (refreshControl) {
        [refreshControl endRefreshing];
    }
}

- (void)fetchMoreHairfies {
    NSLog(@"FETCHING MORE HAIRFIES ******************");
    int value = [currentPage intValue];
    currentPage = [NSNumber numberWithInt:value + 1];;
    [self getHairfies:currentPage];
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
        hairfieDetail.hairfie = (Hairfie*)[hairfies objectAtIndex:hairfieRow];

    }
    if ([segue.identifier isEqualToString:@"cameraOverlay"])
    {
        CameraOverlayViewController *cameraOverlay= [segue destinationViewController];
    
        cameraOverlay.isHairfie = YES;
    }
    
}

@end
