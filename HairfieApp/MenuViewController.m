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
#import <FacebookSDK/FacebookSDK.h>



@implementation MenuViewController
{
    AppDelegate *appDelegate;
    BOOL newBusiness;
    BOOL didInsert;
    NSMutableArray *data;
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
    newBusiness = NO;
    didInsert = NO;
    self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGesturePanning | ECSlidingViewControllerAnchoredGestureTapping;
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentUserChanged:) name:@"currentUser" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(badCredentials:) name:@"badCredentials" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backToLogin:) name:@"backToLogin" object:nil];
    
    [self initCurrentUser];
    
    _menuTableView.backgroundColor = [UIColor clearColor];
    _menuTableView.opaque = NO;
    _menuTableView.backgroundView = nil;
    _menuTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _profileView.backgroundColor = [UIColor clearColor];
   
    _menuItems = [[NSMutableArray alloc] init];
    
    
    _menuItems = [NSMutableArray arrayWithObjects: NSLocalizedStringFromTable(@"Home", @"Menu", nil), /*NSLocalizedStringFromTable(@"Favorites", @"Menu", nil),*/NSLocalizedStringFromTable(@"Likes", @"Menu", nil), /*NSLocalizedStringFromTable(@"Friends", @"Menu", nil),*/NSLocalizedStringFromTable(@"Business", @"Menu", nil),/*NSLocalizedStringFromTable(@"Settings", @"Menu", nil),*/NSLocalizedStringFromTable(@"Logout", @"Menu", nil), nil];
    
    data = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < [_menuItems count] ; i++)
    {
        NSMutableArray* section = [[NSMutableArray alloc] init];
        if ([_menuItems objectAtIndex:i] == NSLocalizedStringFromTable(@"Business", @"Menu", nil))
        {
            [section addObject:@"Add Business"];
        }
        else
            [section addObject:@""];
        [data addObject:section];
    }
    
    _menuPictos = [[NSMutableArray alloc] init];
    [_menuPictos addObject:@"home-picto.png"];
    //[_menuPictos addObject:@"favorites-picto.png"];
    [_menuPictos addObject:@"likes-picto.png"];
    //[_menuPictos addObject:@"friends-picto.png"];
    [_menuPictos addObject:@"business-picto.png"];
    //[_menuPictos addObject:@"settings-picto.png"];
    [_menuPictos addObject:@"picto-logout.png"];
}


-(void)currentUserChanged:(NSNotification*)notification
{
    [self initCurrentUser];
}

-(void)badCredentials:(NSNotification*)notification
{
    [self logOut];
}

-(void) backToLogin:(NSNotification*)notification {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) initCurrentUser
{
    _name.text = appDelegate.currentUser.name;
    _hairfieNb.text = [NSString stringWithFormat:@"%@ hairfies", appDelegate.currentUser.numHairfies];
    
    NSLog(@"current user img url %@", appDelegate.currentUser.thumbUrl);
    
    UIImageView *profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(30, 50, 50, 50)];
    profilePicture.layer.cornerRadius = profilePicture.frame.size.height / 2;
    profilePicture.clipsToBounds = YES;
    profilePicture.layer.borderWidth = 1.0f;
    profilePicture.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    
    [profilePicture sd_setImageWithURL:[NSURL URLWithString:appDelegate.currentUser.thumbUrl] placeholderImage:[UIColor imageWithColor:[UIColor lightGreyHairfie]]];
    
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_menuItems count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    header.backgroundColor = [UIColor lightGrayColor];
    return header;
}


- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (newBusiness == YES)
        [cell setBackgroundColor:[UIColor blueHairfie]];
    else
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
        [self performSegueWithIdentifier:@"LikeSegue" sender:self];
    }
    if (row == 2)
    {
        if (didInsert == NO)
        {
            newBusiness = YES;
        [tableView beginUpdates];
        [_menuItems addObject:@"test activity"];
        [_menuPictos addObject:@"test"];
        NSInteger rowindex = indexPath.row + 1;
        NSArray *paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:rowindex inSection:0]];
        [tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationTop];
        [tableView endUpdates];
            didInsert = YES;
            
        }
        else{
             newBusiness = NO;
            [tableView beginUpdates];
            [_menuItems removeObjectAtIndex:indexPath.row];
            NSInteger rowindex = indexPath.row + 1;
            NSArray *paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:rowindex inSection:0]];
            [tableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationTop];
            [tableView endUpdates];
            didInsert = NO;
        }
    }
    if (row == 3)
    {
        if (newBusiness == YES)
            [self performSegueWithIdentifier:@"BusinessSegue" sender:self];
        else
           [self logOut];
    }
    if (newBusiness == YES)
    {
        if (row == 4)
            [self logOut];
    }
}







-(void)logOut
{
    [appDelegate.credentialStore clearSavedCredentials];
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error on load %@", error.description);
         [self.navigationController popToRootViewControllerAnimated:NO];
    };
    void (^loadSuccessBlock)(NSDictionary *) = ^(NSDictionary *results){
        NSLog(@"results %@", results);
        [FBSession.activeSession closeAndClearTokenInformation];
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
