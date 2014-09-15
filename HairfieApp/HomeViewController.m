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
#import "HairfieDetailViewController.h"
#import "ApplyFiltersViewController.h"
#import "UserRepository.h"


@interface HomeViewController ()
{
    AdvanceSearch *searchView;
    NSArray *hairfies;
    NSInteger hairfieRow;
    UIAlertView *chooseCameraType;
    UIRefreshControl *refreshControl;
    UIGestureRecognizer *dismiss;
}
@end



@implementation HomeViewController

@synthesize imageTaken, searchView = _searchView;

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NSString stringWithFormat:NSLocalizedString(@"Home", nil)];
     [_hairfieCollection registerNib:[UINib nibWithNibName:@"CustomCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"hairfieCell"];
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    _searchView.hidden = YES;
    [_searchView initView];
    [_searchView.searchAroundMeImage setTintColor:[UIColor lightBlueHairfie]];
    _searchView.searchByLocation.text = @"Around Me";

    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(getHairfies)
             forControlEvents:UIControlEventValueChanged];
    [_hairfieCollection addSubview:refreshControl];
   
    [self getHairfies];
     dismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    // Do any additional setup after loading the view.
    
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willSearch:) name:@"searchQuery" object:nil];
    [self getHairfies];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"searchQuery" object:nil];
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


-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    hairfieRow = indexPath.row;
    NSLog(@"select hairfie");
    [self performSegueWithIdentifier:@"hairfieDetail" sender:self];
    
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
        hairfieDetail.currentHairfie = (Hairfie*)[hairfies objectAtIndex:hairfieRow];
       
    }
    if ([segue.identifier isEqualToString:@"cameraFilters"])
    {
        ApplyFiltersViewController *filters = [segue destinationViewController];
        
        filters.hairfie = imageTaken;
    }

}


-(void)getHairfies
{
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error on load %@", error.description);
        [refreshControl endRefreshing];
    };
    void (^loadSuccessBlock)(NSArray *) = ^(NSArray *models){
        hairfies = models;
        [self customReloadData];
    };
    [Hairfie listLatestPerPage:@(0)
                          success:loadSuccessBlock
                          failure:loadErrorBlock];
}

- (void)customReloadData
{
    [_hairfieCollection reloadData];
    if (refreshControl) {
        [refreshControl endRefreshing];
    }
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
