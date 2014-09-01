//
//  MenuViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 28/07/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//


#import "MenuViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MenuTableViewCell.h"
#import "AppDelegate.h"
#import <LoopBack/LoopBack.h>
#import "Constants.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CredentialStore.h"



@implementation MenuViewController
{
    AppDelegate *appDelegate;
}
@synthesize menuTableView = _menuTableView;
@synthesize profileView = _profileView;
@synthesize menuItems = _menuItems;
@synthesize menuPictos = _menuPictos;


- (IBAction)unwindToMenuViewController:(UIStoryboardSegue *)segue {
}

- (void)viewDidLoad
{
    [super viewDidLoad];


    self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGesturePanning | ECSlidingViewControllerAnchoredGestureTapping;
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    _name.text = appDelegate.currentUser.name;
    [self initProfilePicture];
    
    // self.slidingViewController.shouldGroupAccessibilityChildren = YES;
   // [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    _menuTableView.backgroundColor = [UIColor clearColor];
    _menuTableView.opaque = NO;
    _menuTableView.backgroundView = nil;
    _menuTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _profileView.backgroundColor = [UIColor clearColor];
   
       _menuItems = [[NSArray alloc] init];
    _menuItems = [NSArray arrayWithObjects: NSLocalizedString(@"Home", nil), NSLocalizedString(@"Favorites", nil),NSLocalizedString(@"Likes", nil), NSLocalizedString(@"Friends", nil),NSLocalizedString(@"Business", nil),NSLocalizedString(@"Settings", nil),NSLocalizedString(@"Logout", nil), nil];
    
    _menuPictos = [[NSMutableArray alloc] init];
    [_menuPictos addObject:@"home-picto.png"];
    [_menuPictos addObject:@"favorites-picto.png"];
    [_menuPictos addObject:@"likes-picto.png"];
    [_menuPictos addObject:@"friends-picto.png"];
    [_menuPictos addObject:@"business-picto.png"];
    [_menuPictos addObject:@"settings-picto.png"];
    [_menuPictos addObject:@"picto-logout.png"];
}



-(void) initProfilePicture
{
    
    
    UIImageView *profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(60, 50, 50, 50)];
    profilePicture.layer.cornerRadius = profilePicture.frame.size.height / 2;
    profilePicture.clipsToBounds = YES;
    profilePicture.layer.borderWidth = 1.0f;
    profilePicture.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:appDelegate.currentUser.imageLink]
                                                        options:0
                                                       progress:^(NSInteger receivedSize, NSInteger expectedSize) { }
                                                      completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
     {
         if (image && finished)
         {
             
             profilePicture.image = image;
         }
     }];
    
    [_profileView addSubview:profilePicture];
    
    

}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Table view data source
-(void) viewWillAppear:(BOOL)animated
{
  //  [self.slidingViewController.topViewController.view addGestureRecognizer:self.slidingViewController.panGesture];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_menuItems count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MenuCell";
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MenuTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
   
    cell.menuItem.textColor = [UIColor colorWithRed:208 green:210 blue:213 alpha:1];
    cell.menuItem.font = [UIFont fontWithName:@"SourceSansPro-Light" size:15];
    cell.menuItem.text = [_menuItems objectAtIndex:indexPath.row];
    [cell.menuPicto setImage:[UIImage imageNamed:[_menuPictos objectAtIndex:indexPath.row]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
    // cell.imageView.image = [UIImage imageNamed:@"selected-cell.jpg"];

}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    [self.slidingViewController.topViewController.view addGestureRecognizer:self.slidingViewController.panGesture];

    if (row == 0)
    {
        [self performSegueWithIdentifier:@"HomeSegue" sender:self];
    }
    if (row == 1)
    {
        [self performSegueWithIdentifier:@"FavoriteSegue" sender:self];
    }
    if (row == 2)
    {
        [self performSegueWithIdentifier:@"LikeSegue" sender:self];
    }
    if (row == 3)
    {
        [self performSegueWithIdentifier:@"FriendSegue" sender:self];
    }
    if (row == 4)
    {
        [self performSegueWithIdentifier:@"BusinessSegue" sender:self];
    }
    if (row == 5)
    {
        [self performSegueWithIdentifier:@"SettingSegue" sender:self];
    }
    if (row == 6)
    {
        [self logOut];
    }
}


-(void)logOut
{
    [appDelegate.credentialStore clearSavedCredentials];
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error on load %@", error.description);
    };
    void (^loadSuccessBlock)(NSDictionary *) = ^(NSDictionary *results){
        NSLog(@"results %@", results);
        
        [self.navigationController popToRootViewControllerAnimated:NO];
    };
    
    NSString *repoName = @"users";
   // NSLog(@"Token %@", [AppDelegate lbAdaptater].accessToken);
    
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/users/logout" verb:@"POST"] forMethod:@"users.logout"];
    
    LBModelRepository *logOutData = [[AppDelegate lbAdaptater] repositoryWithModelName:repoName];
    [logOutData invokeStaticMethod:@"logout" parameters:@{} success:loadSuccessBlock failure:loadErrorBlock];
    
}

#pragma mark state preservation / restoration
- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // TODO save what you need here
    
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // TODO restore what you need here
    
    [super decodeRestorableStateWithCoder:coder];
}

- (void)applicationFinishedRestoringState {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // TODO call whatever function you need to visually restore
}

@end
