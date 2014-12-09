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
#import "Hairdresser.h"
#import "BusinessViewController.h"
#import "HairdresserDetailViewController.h"

@interface FavoriteViewController ()

@end

@implementation FavoriteViewController
{
    NSArray *favoriteHairdressers;
    AppDelegate *appDelegate;
    
    Business *selectedBusiness;
    Hairdresser *selectedHairdresser;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    
       
    [self getFavoriteHairdressers];
    
    [self.topView addBottomBorderWithHeight:1.0 andColor:[UIColor lightGrey]];
    // Do any additional setup after loading the view.
}


-(void)getFavoriteHairdressers {
    
    
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error  %@", [error userInfo]);
    };
    void (^loadSuccessBlock)(NSArray *) = ^(NSArray *result){
        favoriteHairdressers = result;
        self.tableViewHeight.constant = favoriteHairdressers.count * 100;
        if (self.tableViewHeight.constant > self.view.bounds.size.height - 64)
            self.tableViewHeight.constant = self.view.bounds.size.height - 64;
        [self.tableView reloadData];
    };
    [User getFavoriteHairdressers:appDelegate.currentUser.id success:loadSuccessBlock failure:loadErrorBlock];
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
    Hairdresser *hairdresser = [[Hairdresser alloc] initWithDictionary:[[favoriteHairdressers objectAtIndex:indexPath.row]objectForKey:@"hairdresser"]];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setupCell:hairdresser];
  
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return favoriteHairdressers.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedHairdresser = [[Hairdresser alloc] initWithDictionary:[[favoriteHairdressers objectAtIndex:indexPath.row]objectForKey:@"hairdresser"]];
    [self getBusiness:selectedHairdresser];
}


-(void)getBusiness:(Hairdresser*)hairdresser{
    
    
    [Business getById:hairdresser.business.id withSuccess:^(Business *business) {
        selectedBusiness = business;
        
        [self performSegueWithIdentifier:@"showHairdresser" sender:self];
        
    }
              failure:^(NSError *error) {
                  NSLog(@"Failed to retrieve complete business: %@", error.localizedDescription);
              }];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showHairdresser"]){
        HairdresserDetailViewController *hairdresserVc = [segue destinationViewController];
        hairdresserVc.hairdresser = selectedHairdresser;
        hairdresserVc.business = selectedBusiness;
    }
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
