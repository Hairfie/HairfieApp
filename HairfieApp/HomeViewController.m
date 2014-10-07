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

#define CUSTOM_CELL_IDENTIFIER @"hairfieCell"
#define LOADING_CELL_IDENTIFIER @"LoadingItemCell"


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
}
@end



@implementation HomeViewController

@synthesize searchView = _searchView, menuButton = _menuButton, topBarView = _topBarView;

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    [delegate startTrackingLocation:YES];

    self.navigationItem.title = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Home", @"Feed", nil)];
    [_hairfieCollection registerNib:[UINib nibWithNibName:@"CustomCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CUSTOM_CELL_IDENTIFIER];
    [_hairfieCollection registerNib:[UINib nibWithNibName:@"LoadingCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:LOADING_CELL_IDENTIFIER];

    _searchView.hidden = YES;
    _searchView.businessSearch = [[BusinessSearch alloc] init];
    [_searchView initView];
    [_searchView.searchAroundMeImage setTintColor:[UIColor pinkBtnHairfie]];
    _searchView.searchByLocation.text = NSLocalizedStringFromTable(@"Around Me", @"Feed", nil);

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
    
    
    // Do any additional setup after loading the view.

}


-(IBAction)checkManaged:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"currentUser" object:self];
}
-(void) hideKeyboard
{
    [_searchView.searchByLocation resignFirstResponder];
    [_searchView.searchByName resignFirstResponder];
    _searchView.hidden = YES;
    [self.view removeGestureRecognizer:dismiss];
}


-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willSearch:)
                                                 name:self.searchView.businessSearch.changedEventName
                                               object:self.searchView.businessSearch];

    [self getHairfies:nil];
    [ARAnalytics pageView:@"AR - Feed"];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:self.searchView.businessSearch.changedEventName
                                                  object:self.searchView.businessSearch];

    [self.view removeGestureRecognizer:dismiss];
}


-(void)willSearch:(NSNotification*)notification
{
    [self performSegueWithIdentifier:@"searchFromFeed" sender:self];
    [self.view removeGestureRecognizer:dismiss];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //_advancedSearchView.hidden = NO;

    _searchView.hidden = NO;
    [self.view addGestureRecognizer:dismiss];
    if ([_searchView.searchByLocation.text isEqualToString:NSLocalizedStringFromTable(@"Around Me", @"Feed", nil)])
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [hairfies count]) {
        return CGSizeMake(145, 210);
    } else {
        return CGSizeMake(300, 58);
    }
}

// header view data source

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];

    return headerView;
}


- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [hairfies count] + 1;
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}


// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [hairfies count]) {

        if(indexPath.row == ([hairfies count] - HAIRFIES_PAGE_SIZE + 1)){
            [self fetchMoreHairfies];
        }

        return [self hairfieCellForIndexPath:indexPath];
    } else {
        return [self loadingCellForIndexPath:indexPath];
    }
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


-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    hairfieRow = indexPath.row;
    NSLog(@"select hairfie");
    [self performSegueWithIdentifier:@"hairfieDetail" sender:self];

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
            //[hairfies addObject:models[i]];
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
    if ([segue.identifier isEqualToString:@"camera"])
    {
        UIImagePickerController *pickerController = [segue destinationViewController];
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerController.delegate = self;
    
    }
    if ([segue.identifier isEqualToString:@"searchFromFeed"])
    {
        AroundMeViewController *controller = [segue destinationViewController];
        controller.businessSearch = self.searchView.businessSearch;
    }
    if ([segue.identifier isEqualToString:@"hairfieDetail"])
    {
        HairfieDetailViewController *hairfieDetail = [segue destinationViewController];
        hairfieDetail.hairfie = (Hairfie*)[hairfies objectAtIndex:hairfieRow];

    }
}

@end
