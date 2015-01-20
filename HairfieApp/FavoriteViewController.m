//
//  FavoriteViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 29/07/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "AppDelegate.h"
#import "FavoriteViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "FavoriteCell.h"
#import "BusinessMember.h"
#import "BusinessViewController.h"
#import "BusinessMemberViewController.h"
#import "BusinessMemberFavorite.h"

@interface FavoriteViewController ()

@end

@implementation FavoriteViewController
{
    NSArray *favoriteBusinessMembers;
    AppDelegate *appDelegate;
    
    Business *selectedBusiness;
    BusinessMember *selectedBusinessMember;
    BOOL isBusiness;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headerTitle.text = NSLocalizedStringFromTable(@"Favorites", @"Menu", nil);
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(segueToBusiness:) name:@"goToBusiness" object:nil];
     
    [self getFavoriteBusinessMembers];
    
    [self.topView addBottomBorderWithHeight:1.0 andColor:[UIColor lightGrey]];
    // Do any additional setup after loading the view.
}

-(void)segueToBusiness:(NSNotification*)notification
{
    NSDictionary *notificationInfo = notification.userInfo;
    NSString *businessId = [notificationInfo objectForKey:@"businessId"];
    isBusiness = YES;
    [self getBusiness:businessId];
    
}
     
-(void)getFavoriteBusinessMembers
{
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error  %@", [error userInfo]);
    };
    void (^loadSuccessBlock)(NSArray *) = ^(NSArray *result){
        favoriteBusinessMembers = result;
        self.tableViewHeight.constant = favoriteBusinessMembers.count * 100;
        if (self.tableViewHeight.constant > self.view.bounds.size.height - 64)
            self.tableViewHeight.constant = self.view.bounds.size.height - 64;
        [self.tableView reloadData];
    };

    [BusinessMemberFavorite getBusinessMemberFavoritesByUser:appDelegate.currentUser.id
                                                 withSuccess:loadSuccessBlock
                                                     failure:loadErrorBlock];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FavoriteCell";
    FavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FavoriteCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.indentationWidth = 0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    BusinessMember *businessMember = [[favoriteBusinessMembers objectAtIndex:indexPath.row] businessMember];

    if ([businessMember.firstName length] > 0) {
        [cell setBusinessMember:businessMember];
    } else {
        [cell setHidden:YES];
    }

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return favoriteBusinessMembers.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedBusinessMember = [favoriteBusinessMembers[indexPath.row] businessMember];
    isBusiness = NO;
    [self getBusiness:selectedBusinessMember.business.id];
}


-(void)getBusiness:(NSString*)businessId
{
    [Business getById:businessId withSuccess:^(Business *business) {
                                    selectedBusiness = business;
                                    if (isBusiness == YES) {
                                        [self performSegueWithIdentifier:@"showBusiness" sender:self];
                                    } else {
                                        [self performSegueWithIdentifier:@"showHairdresser" sender:self];
                                    }
                                }
                                    failure:^(NSError *error) {
                                        NSLog(@"Failed to retrieve complete business: %@", error.localizedDescription);
                                    }];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showHairdresser"]){
        BusinessMemberViewController *vc = [segue destinationViewController];
        vc.businessMember = selectedBusinessMember;
        vc.business = selectedBusiness;
    }
    if ([segue.identifier isEqualToString:@"showBusiness"]) {
        BusinessViewController *businessVc = [segue destinationViewController];
        businessVc.business = selectedBusiness;
    }
}

@end
