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
    NSMutableArray *headers;
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
    [self setupMenu];
    [_menuTableView reloadData];
    [_menuTableView setExclusiveSections:!_menuTableView.exclusiveSections];
    [_menuTableView openSection:0 animated:NO];
    [_menuTableView openSection:1 animated:NO];
    [_menuTableView openSection:2 animated:NO];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];

   
    
   //  (void)selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition
    [_menuTableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self tableView:_menuTableView didSelectRowAtIndexPath:path];
    //[_menuTableView reloadData];
    
    _menuTableView.backgroundColor = [UIColor clearColor];
    _menuTableView.opaque = NO;
    _menuTableView.backgroundView = nil;
    _menuTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _profileView.backgroundColor = [UIColor clearColor];
   
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


- (void)setupMenu
{
    
    _menuTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _menuItems = [[NSMutableArray alloc] init];
    
    
    _menuItems = [NSMutableArray arrayWithObjects: NSLocalizedStringFromTable(@"Home", @"Menu", nil), NSLocalizedStringFromTable(@"Likes", @"Menu", nil), nil];
    _menuPictos = [[NSMutableArray alloc] init];
    [_menuPictos addObject:@"home-picto.png"];
    [_menuPictos addObject:@"likes-picto.png"];
    
    data = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < 3 ; i++)
    {
        NSMutableArray* section = [[NSMutableArray alloc] init];
        
        if (i == 0)
            for (int j = 0 ; j < 2 ; j++)
            {
                [section addObject:[NSString stringWithFormat:@"%@", [_menuItems objectAtIndex:j]]];
            }
        else
            [section addObject:[NSString stringWithFormat:@"Add a business"]];
        
        [data addObject:section];
    }
    
    
    headers = [[NSMutableArray alloc] init];
    
    UIView* header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [header setBackgroundColor:[UIColor lightGrayColor]];
    UILabel *mylabel = [[UILabel alloc] initWithFrame:CGRectMake(52, 0, 237, 40)];
    mylabel.text = @"Business";
    UIImageView *pictoBusiness = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 20, 20)];
    pictoBusiness.image = [UIImage imageNamed:@"business-picto.png"];
    mylabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:15];
    mylabel.textColor = [UIColor whiteColor];
    [header addSubview:pictoBusiness];
    [header addSubview:mylabel];
    [headers addObject:header];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MenuCell";
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MenuTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.backgroundColor = [UIColor lightGrayColor];
    if (indexPath.section == 0)
    {
        cell.menuItem.text = [_menuItems objectAtIndex:indexPath.row];
        [cell.menuPicto setImage:[UIImage imageNamed:[_menuPictos objectAtIndex:indexPath.row]]];
        
    }
    if (indexPath.section == 1)
    {
        cell.menuItem.text = @"Add a business";
        [cell.menuPicto setImage:[UIImage imageNamed:@"addBusiness-picto.png"]];
    }
    if (indexPath.section == 2)
    {
        [cell.menuPicto setImage:[UIImage imageNamed:@"picto-logout.png"]];
        cell.menuItem.text = @"Log Out";
        
    }
     cell.selectionIndicator.hidden = YES;
    cell.menuItem.textColor = [UIColor colorWithRed:208 green:210 blue:213 alpha:1];
    cell.menuItem.font = [UIFont fontWithName:@"SourceSansPro-Light" size:15];
    cell.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 2;
    else
        return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1)
        return 44;
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section == 1)
        return [headers objectAtIndex:0];
    else
        
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuTableViewCell *cell = (MenuTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];

     cell.selectionIndicator.hidden = NO;
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            [self performSegueWithIdentifier:@"HomeSegue" sender:self];
        }
        if (indexPath.row == 1)
        {
            [self performSegueWithIdentifier:@"LikeSegue" sender:self];
        }
    }
    if (indexPath.section == 1)
    {
        [self performSegueWithIdentifier:@"BusinessSegue" sender:self];
    }
 
    if (indexPath.section == 2)
        [self logOut];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
     MenuTableViewCell *cell = (MenuTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
   cell.selectionIndicator.hidden = YES;
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
