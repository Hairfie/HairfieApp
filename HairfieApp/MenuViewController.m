//
//  MenuViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 28/07/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//


#import "MenuViewController.h"
#import "FinalStepViewController.h"
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
    NSArray *managedBusinesses;
    Business *businessToManage;
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
    [self initManagedBusinesses];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [_menuTableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self tableView:_menuTableView didSelectRowAtIndexPath:path];

    [_menuTableView reloadData];
    [_menuTableView setExclusiveSections:!_menuTableView.exclusiveSections];
    [_menuTableView openSection:0 animated:NO];
    [_menuTableView openSection:1 animated:NO];
    [_menuTableView openSection:2 animated:NO];
    
    _menuTableView.backgroundColor = [UIColor whiteColor];
    _profileView.backgroundColor = [UIColor clearColor];
   
}


-(void)currentUserChanged:(NSNotification*)notification
{
    [self initCurrentUser];
    [self initManagedBusinesses];
    if ([managedBusinesses count] > 0)
        [self setupMenu];
}

-(void)badCredentials:(NSNotification*)notification
{
    [self logOut];
}

-(void) backToLogin:(NSNotification*)notification {
    [appDelegate showLoginStoryboard];
}

-(void) initCurrentUser
{
    _name.text = appDelegate.currentUser.name;
    _hairfieNb.text = [NSString stringWithFormat:@"%@ hairfies", appDelegate.currentUser.numHairfies];
    
    NSLog(@"current user img url %@", appDelegate.currentUser.thumbUrl);
    
    UIImageView *profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(90, 30, 92, 92)];
    profilePicture.layer.cornerRadius = profilePicture.frame.size.height / 2;
    profilePicture.clipsToBounds = YES;

    UIView *border =[[UIView alloc] initWithFrame:CGRectMake(85, 25, 102, 102)];
    border.layer.cornerRadius = border.frame.size.height / 2;
    border.clipsToBounds = YES;
    border.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];

    
    
    
    [profilePicture sd_setImageWithURL:[NSURL URLWithString:appDelegate.currentUser.thumbUrl] placeholderImage:[UIColor imageWithColor:[UIColor lightGreyHairfie]]];
  
    [_profileView addSubview:border];
    [_profileView addSubview:profilePicture];
  
}

-(void)initManagedBusinesses
{
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error : %@", error.description);
    };
    void (^loadSuccessBlock)(NSArray *) = ^(NSArray *results){
        managedBusinesses = results;
        [self setupMenu];
        [_menuTableView reloadData];
    };

    
    [appDelegate.currentUser getManagedBusinessesByUserSuccess:loadSuccessBlock failure:loadErrorBlock];
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

     _menuItems = [[NSMutableArray alloc] init];
    
    
    _menuItems = [NSMutableArray arrayWithObjects: NSLocalizedStringFromTable(@"Home", @"Menu", nil), NSLocalizedStringFromTable(@"Likes", @"Menu", nil), nil];
    _menuPictos = [[NSMutableArray alloc] init];
    
    [_menuPictos addObject:@"picto-home.png"];
    [_menuPictos addObject:@"picto-like.png"];
    
    data = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < 3 ; i++)
    {
        NSMutableArray* section = [[NSMutableArray alloc] init];
        if (i == 0)
        {
            for (int j = 0 ; j < 2 ; j++)
            {
                [section addObject:[NSString stringWithFormat:@"%@", [_menuItems objectAtIndex:j]]];
            }
        }
        else if (i == 1)
        {
            for(int j = 0; j < [managedBusinesses count]; j++)
            {
                [section addObject:@"claimed business"];
            }
            [section addObject:[NSString stringWithFormat:@"add business"]];
        }
        
        
        [data addObject:section];

    }
    
    
    headers = [[NSMutableArray alloc] init];
    
    UIView* header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 46)];
    [header setBackgroundColor:[UIColor whiteColor]];
    UILabel *mylabel = [[UILabel alloc] initWithFrame:CGRectMake(52, 0, 237, 40)];
    mylabel.text = @"Business";
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, 320, 1)];\
    separatorView.backgroundColor = [UIColor colorWithRed:236/255.0f green:236/255.0f blue:238/255.0f alpha:1];
    UIView *topseparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];\
    topseparatorView.backgroundColor = [UIColor colorWithRed:236/255.0f green:236/255.0f blue:238/255.0f alpha:1];
    UIImageView *pictoBusiness = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 20, 20)];
    pictoBusiness.image = [UIImage imageNamed:@"picto-home.png"];
    mylabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:15];
    mylabel.textColor = [UIColor colorWithRed:103/255.0f green:111/255.0f blue:116/255.0f alpha:1];
    [header addSubview:topseparatorView];
    [header addSubview:separatorView];
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


    if (indexPath.section == 0)
    {
        cell.menuItem.text = [_menuItems objectAtIndex:indexPath.row];
      
        [cell.menuPicto setImage:[UIImage imageNamed:[_menuPictos objectAtIndex:indexPath.row]]];
           cell.indentationWidth = 0;
    }
    if (indexPath.section == 1)
    {
        
        if (indexPath.row < [managedBusinesses count])
        {
             Business *managedBusiness = [[Business alloc] initWithDictionary: [managedBusinesses objectAtIndex:indexPath.row]];
            
            Picture *pic = [managedBusiness.pictures objectAtIndex:0];
            
            cell.menuItem.text = managedBusiness.name;
            UIImageView *businessPic = [[UIImageView alloc] initWithFrame:cell.menuPicto.frame];
            
            NSNumber *sideLength = [NSNumber numberWithInt:cell.menuPicto.frame.size.height * 2];
            
            [businessPic sd_setImageWithURL:[NSURL URLWithString:[pic urlWithWidth:sideLength height:sideLength]]
                                placeholderImage:[UIColor imageWithColor:[UIColor salonDetailTab]]];
           
            cell.menuPicto.layer.cornerRadius = cell.menuPicto.frame.size.height / 2;
            cell.menuPicto.clipsToBounds = YES;
            cell.menuPicto.layer.borderWidth = 1.0f;
            cell.menuPicto.layer.borderColor = [UIColor lightGreyHairfie].CGColor;

            [cell.menuPicto setImage:businessPic.image];
        }
        else
        {
            cell.menuItem.text = @"Add a business";
            [cell.menuPicto setImage:[UIImage imageNamed:@"picto-add.png"]];
        }
        
        cell.backgroundColor = [UIColor colorWithRed:236/255.0f green:236/255.0f blue:238/255.0f alpha:1];
    }
    if (indexPath.section == 2)
    {
        [cell.menuPicto setImage:[UIImage imageNamed:@"picto-logout.png"]];
        cell.menuItem.text = @"Log Out";
        cell.indentationWidth = 0;
    }
    cell.selectionIndicator.hidden = YES;
    cell.menuItem.font = [UIFont fontWithName:@"SourceSansPro-Light" size:15];
    cell.menuItem.textColor = [UIColor colorWithRed:103/255.0f green:111/255.0f blue:116/255.0f alpha:1];
    cell.menuPicto.contentMode = UIViewContentModeScaleAspectFit;
    cell.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 2;
    if (section == 1)
        return 1 + [managedBusinesses count];
    else
        return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1)
        return 45;
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
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
        if (indexPath.row < [managedBusinesses count])
        {
            businessToManage = [[Business alloc] initWithDictionary: [managedBusinesses objectAtIndex:indexPath.row]];
            [self performSegueWithIdentifier:@"ManageBusiness" sender:self];
        }
        else
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
        [appDelegate showLoginStoryboard];
    };
    void (^loadSuccessBlock)(NSDictionary *) = ^(NSDictionary *results){
        NSLog(@"results %@", results);
        [FBSession.activeSession closeAndClearTokenInformation];
        [appDelegate showLoginStoryboard];
    };
    
    NSString *repoName = @"users";
   // NSLog(@"Token %@", [AppDelegate lbAdaptater].accessToken);
    
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/users/logout" verb:@"POST"] forMethod:@"users.logout"];
    
    LBModelRepository *logOutData = [[AppDelegate lbAdaptater] repositoryWithModelName:repoName];
    [logOutData invokeStaticMethod:@"logout" parameters:@{} success:loadSuccessBlock failure:loadErrorBlock];
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ManageBusiness"])
    {
        UINavigationController *navController = (UINavigationController*)[segue destinationViewController];
        FinalStepViewController *claimVc = [navController.viewControllers objectAtIndex:0];
        
        [claimVc setBusinessToManage:businessToManage];
     
    }
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
