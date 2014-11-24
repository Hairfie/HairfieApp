//
//  BusinessViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 11/24/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "BusinessViewController.h"
#import "Hairfie.h"
#import "Service.h"
#import "Hairdresser.h"

#import "LoadingCollectionViewCell.h"
#import "CustomCollectionViewCell.h"
#import "BusinessDetailCollectionViewCell.h"
#import "BusinessHairdressersCollectionViewCell.h"
#import "BusinessServicesCollectionViewCell.h"

#import "BusinessReusableView.h"

@interface BusinessViewController ()

@end

@implementation BusinessViewController
{
    BOOL isHairfiesTab;
    BOOL isHairdressersTab;
    BOOL isDetailsTab;
    BOOL isServicesTab;
    
    NSMutableArray *businessHairfies;

    BOOL endOfHairfies;
    BOOL loadingHairfies;

}

#define HAIRFIE_CELL @"hairfieCell"
#define LOADING_CELL @"loadingCell"
#define DETAILS_CELL @"detailsCell"
#define HAIRDRESSERS_CELL @"businessHairdresserCell"
#define SERVICES_CELL @"businessServiceCell"

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isDetailsTab = YES;
    self.leftMenuBttn.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showBusinessDetails:)
                                                 name:@"businessDetails"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showBusinessHairfies:)
                                                 name:@"businessHairfies"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showBusinessHairdressers:)
                                                 name:@"businessHairdressers"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showBusinessServices:)
                                                 name:@"businessServices"
                                               object:nil];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CustomCollectionViewCell" bundle:nil]forCellWithReuseIdentifier:HAIRFIE_CELL];
    [self.collectionView registerNib:[UINib nibWithNibName:@"LoadingCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:LOADING_CELL];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BusinessDetailCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:DETAILS_CELL];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BusinessHairdressersCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:HAIRDRESSERS_CELL];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BusinessServicesCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:SERVICES_CELL];
    
    [self initData];
    // Do any additional setup after loading the view.
}

-(void)initData
{
    [self setupHairfies];
}


-(void)showBusinessDetails:(NSNotification*)notification {
    isDetailsTab = YES;
    isHairfiesTab = NO;
    isServicesTab = NO;
    isHairdressersTab = NO;
    [self.collectionView reloadData];
}

-(void)showBusinessHairfies:(NSNotification*)notification {
    isHairfiesTab = YES;
    isDetailsTab = NO;
    isServicesTab = NO;
    isHairdressersTab = NO;
    [self.collectionView reloadData];
}

-(void)showBusinessHairdressers:(NSNotification*)notification {
    isHairdressersTab = YES;
    isHairfiesTab = NO;
    isDetailsTab = NO;
    isServicesTab = NO;
    [self.collectionView reloadData];
}

-(void)showBusinessServices:(NSNotification*)notification {
    isServicesTab = YES;
    isHairdressersTab = NO;
    isHairfiesTab = NO;
    isDetailsTab = NO;
    [self.collectionView reloadData];
}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupHairfies
{
    businessHairfies = [[NSMutableArray alloc] init];
    endOfHairfies = NO;
    loadingHairfies = NO;
    
    [self loadHairfies];
}

-(void)loadHairfies
{
    if (endOfHairfies || loadingHairfies) return;
    
    NSLog(@"Loading next hairfies");
    
    NSDate *until = nil;
    if (businessHairfies.count > 0) {
        until = [businessHairfies[0] createdAt];
    }
    
    loadingHairfies = YES;
    
    [Hairfie listLatestByBusiness:self.business.id
                            until:until
                            limit:[NSNumber numberWithInt:HAIRFIES_PAGE_SIZE]
                             skip:[NSNumber numberWithLong:businessHairfies.count]
                          success:^(NSArray *results) {
                              NSLog(@"Got hairfies");
                              
                              if (results.count < HAIRFIES_PAGE_SIZE) {
                                  NSLog(@"End of hairfies detected");
                                  endOfHairfies = YES;
                              }
                              
                              for (Hairfie *result in results) {
                                  if (![businessHairfies containsObject:result]) {
                                      [businessHairfies addObject:result];
                                  }
                              }
                              
                              NSLog(@"COUNT %zd", businessHairfies.count);
                              [self.collectionView reloadData];
                              
                              loadingHairfies = NO;
                          }
                          failure:^(NSError *error) {
                              NSLog(@"%@", error.localizedDescription);
                              loadingHairfies = NO;
                          }];
}


-(NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    if (isDetailsTab == YES)
        return 1;
    if (isHairdressersTab == YES)
        return self.business.activeHairdressers.count;
    if (isServicesTab == YES)
        return self.business.services.count;
    if (isHairfiesTab == YES)
        return businessHairfies.count + 2;
    
    return 1;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (isHairfiesTab == YES)
        return UIEdgeInsetsMake(10 , 10, 0, 10);
    return UIEdgeInsetsMake(0 , 0, 0, 0);
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView = nil;
    
    BusinessReusableView *userHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"businessHeaderView" forIndexPath:indexPath];
    
    [userHeader setupView];
    headerView = userHeader;
    return headerView;
    
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (isHairdressersTab == YES)
        return CGSizeMake(320, 45);
    if (isServicesTab == YES)
        return CGSizeMake(320, 45);
    if (isDetailsTab == YES)
        return CGSizeMake(320, 297);
    if (isHairfiesTab == YES) {
        if (indexPath.row < (businessHairfies.count + 1)) {
            return CGSizeMake(145, 210);
        } else {
            
            return CGSizeMake(300, 58);
        }
    }
    else
        return CGSizeMake(320, 127);
   
}




-(UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (isServicesTab == YES)
        return [self serviceCellForItemAtIndexPath:indexPath];
    if (isHairdressersTab == YES)
        return [self hairdresserCellForItemAtIndexPath:indexPath];
    if (isDetailsTab == YES)
        return [self detailCellAtIndexPath:indexPath];
    if (isHairfiesTab == YES) {
        if (indexPath.row == 0) {
            return [self newHairfieCellForItemAtIndexPath:indexPath];
        }
        else if (indexPath.row < (businessHairfies.count + 1)) {
            if (indexPath.row >= (businessHairfies.count - HAIRFIES_PAGE_SIZE + 1)) {
                [self loadHairfies];
            }
            return [self hairfieCellAtIndexPath:indexPath];
        } else {
            return [self loadingCellAtIndexPath:indexPath];
        }
    }
    return nil;
}



-(UICollectionViewCell *)serviceCellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BusinessServicesCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"businessServiceCell" forIndexPath:indexPath];
    
    Service *service = [self.business.services objectAtIndex:indexPath.row];
   
    [cell setService:service];
    
    return cell;
}


-(UICollectionViewCell *)hairdresserCellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BusinessHairdressersCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"businessHairdresserCell" forIndexPath:indexPath];
    
    Hairdresser *hairdresser = [self.business.activeHairdressers objectAtIndex:indexPath.row];
    [cell setHairdresser:hairdresser];
    
    return cell;
}
-(UICollectionViewCell *)newHairfieCellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"hairfieCell" forIndexPath:indexPath];
    
    [cell setAsNewHairfieButton];
    
    return cell;
}

-(UICollectionViewCell *)detailCellAtIndexPath:(NSIndexPath *)indexPath
{
    BusinessDetailCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:DETAILS_CELL forIndexPath:indexPath];
    
    return cell;
}
-(UICollectionViewCell *)loadingCellAtIndexPath:(NSIndexPath *)indexPath
{
    LoadingCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:LOADING_CELL forIndexPath:indexPath];
    
    if (endOfHairfies) {
        [cell showEndOfScroll];
    }
    
    return cell;
}


-(UICollectionViewCell *)hairfieCellAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:HAIRFIE_CELL
                                                                                    forIndexPath:indexPath];
    

    [cell setHairfie:businessHairfies[indexPath.item - 1]];
    
    return cell;
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
