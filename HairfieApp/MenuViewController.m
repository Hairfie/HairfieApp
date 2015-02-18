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
#import "UIRoundImageView.h"
#import "UIImage+Filters.h"
#import "UserProfileViewController.h"

#define DEFAULT_PICTURE_URL @"default-user-picture.png"
#define DEFAULT_PICTURE_URL_BG @"default-user-picture-bg.png"

@implementation MenuViewController
{
    AppDelegate *appDelegate;
    BOOL newBusiness;
    BOOL didInsert;
    NSMutableArray *data;
    NSMutableArray *headers;
    NSArray *managedBusinesses;
    Business *businessToManage;
    UIImageView *profilePicture;
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
    
    
    _homeVc = (HomeViewController*)self.slidingViewController.topViewController;
   // self.slidingViewController.topViewController = self.homeVc;
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

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userChanged:)
                                                 name:[User EVENT_CHANGED]
                                               object:nil];
    
    self.slidingViewController.topViewController = self.homeVc;
     [self.slidingViewController resetTopViewAnimated:YES];
   
}

-(void)userChanged:(NSNotification *)aNotification
{
    User *eventUser = aNotification.object;
    User *displayUser = appDelegate.currentUser;
    
    if (displayUser == eventUser) {
        [self initCurrentUser];
    }
}

-(void)currentUserChanged:(NSNotification*)notification
{
    NSLog(@"### CURRENT USER CHANGED ###");
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
    _hairfieNb.text = [appDelegate.currentUser displayHairfies];
    NSLog(@"user email %@", appDelegate.currentUser.email);
  
    profilePicture = [[UIRoundImageView alloc] initWithFrame:CGRectMake(90, 30, 92, 92)];
    profilePicture.clipsToBounds = YES;
    profilePicture.contentMode = UIViewContentModeScaleAspectFit;
    UIView *border =[[UIView alloc] initWithFrame:CGRectMake(85, 25, 102, 102)];
    border.layer.cornerRadius = border.frame.size.height / 2;
    border.clipsToBounds = YES;
    border.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    

    if (appDelegate.currentUser.picture != nil) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        
        
        [manager downloadImageWithURL:[appDelegate.currentUser pictureUrlWithWidth:@50 height:@50]
                              options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize)
         {
             // progression tracking code
         }
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
         {
             if (image)
             {
                 _profileImageView.image = [image applyLightEffect];
             }
         }];
        _profileImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [profilePicture sd_setImageWithURL:[appDelegate.currentUser pictureUrlWithWidth:@200 height:@200]
                          placeholderImage:[UIColor imageWithColor:[UIColor lightGreyHairfie]]];
        
    }else {
        
        [profilePicture setImage:[UIImage imageNamed:DEFAULT_PICTURE_URL]];
        
        _profileImageView.image = [[UIImage imageNamed:DEFAULT_PICTURE_URL_BG] applyLightEffect];
    }
    
    [_profileView addSubview:border];
    [_profileView addSubview:profilePicture];
    
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserProfileFromImage:)];
    [singleTap setNumberOfTapsRequired:1];
    [_profileView addGestureRecognizer:singleTap];
    
}

-(void)showUserProfileFromImage:(UIGestureRecognizer*)gesture
{
    [self showUserProfile:self];
}


-(void)initManagedBusinesses
{
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error : %@", error.description);
    };
    void (^loadSuccessBlock)(void) = ^(void){
        managedBusinesses = appDelegate.currentUser.managedBusinesses;
        [self setupMenu];
        [_menuTableView reloadData];
    };
    [appDelegate.currentUser getManagedBusinessesByUserSuccess:loadSuccessBlock failure:loadErrorBlock];
}


#pragma mark - Table view data source
-(void) viewWillAppear:(BOOL)animated
{
   
}


- (void)setupMenu
{
    _menuItems = [[NSMutableArray alloc] init];
    _menuItems = [NSMutableArray arrayWithObjects: NSLocalizedStringFromTable(@"Home", @"Menu", nil), NSLocalizedStringFromTable(@"Likes", @"Menu", nil), NSLocalizedStringFromTable(@"Favorites", @"Menu", nil), nil];
    _menuPictos = [[NSMutableArray alloc] init];
    [_menuPictos addObject:@"picto-home.png"];
    [_menuPictos addObject:@"picto-like.png"];
    [_menuPictos addObject:@"picto-fav.png"];
    data = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < 3 ; i++)
    {
        NSMutableArray* section = [[NSMutableArray alloc] init];
        if (i == 0)
        {
            for (int j = 0 ; j < 3 ; j++)
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
    
    UIView* header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [header setBackgroundColor:[UIColor whiteColor]];
    UILabel *mylabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 14, 237, 28)];
    mylabel.text = NSLocalizedStringFromTable(@"Business", @"Menu", nil);
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, 320, 1)];\
    separatorView.backgroundColor = [UIColor colorWithRed:236/255.0f green:236/255.0f blue:238/255.0f alpha:1];
    UIView *topseparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];\
    topseparatorView.backgroundColor = [UIColor colorWithRed:236/255.0f green:236/255.0f blue:238/255.0f alpha:1];
    UIImageView *pictoBusiness = [[UIImageView alloc] initWithFrame:CGRectMake(30, 20, 15, 15)];
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
        if (indexPath.row == 0) {
            cell.selectionIndicator.hidden = NO;
        }
        else
            cell.selectionIndicator.hidden = YES;
        
    }
    if (indexPath.section == 1)
    {
        cell.selectionIndicator.hidden = YES;
        if (indexPath.row == 0)
        {
            cell.menuItem.text = NSLocalizedStringFromTable(@"Add a business", @"Menu", nil);
            cell.menuPicto.layer.borderColor = [UIColor clearColor].CGColor;
            [cell.menuPicto setImage:[UIImage imageNamed:@"picto-add.png"]];
            cell.backgroundColor = [UIColor colorWithRed:236/255.0f green:236/255.0f blue:238/255.0f alpha:1];
        }
        if (indexPath.row <= [managedBusinesses count] && indexPath.row > 0)
        {
             Business *managedBusiness = [managedBusinesses objectAtIndex:indexPath.row -1];
            
            Picture *pic = [managedBusiness.pictures objectAtIndex:0];
            
            cell.menuItem.text = managedBusiness.name;
            UIImageView *businessPic = [[UIImageView alloc] initWithFrame:cell.menuPicto.frame];
            
            NSNumber *sideLength = [NSNumber numberWithInt:cell.menuPicto.frame.size.height * 2];
            
            [businessPic sd_setImageWithURL:[pic urlWithWidth:sideLength height:sideLength]
                                placeholderImage:[UIColor imageWithColor:[UIColor salonDetailTab]]];
           
            cell.menuPicto.layer.cornerRadius = cell.menuPicto.frame.size.height / 2;
            cell.menuPicto.clipsToBounds = YES;
            cell.menuPicto.layer.borderWidth = 1.0f;
            cell.menuPicto.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
             cell.backgroundColor = [UIColor colorWithRed:236/255.0f green:236/255.0f blue:238/255.0f alpha:1];
            [cell.menuPicto setImage:businessPic.image];
        }
 
    }
    if (indexPath.section == 2)
    {
        if (indexPath.row == 0) {
        cell.selectionIndicator.hidden = YES;
         cell.backgroundColor = [UIColor whiteColor];
        [cell.menuPicto setImage:[UIImage imageNamed:@"picto-logout.png"]];
        cell.menuItem.text = NSLocalizedStringFromTable(@"Log out", @"Menu", nil);
        cell.menuPicto.layer.borderColor = [UIColor clearColor].CGColor;
        cell.indentationWidth = 0;
        }
        else if (indexPath.row == 1)
        {
            cell.selectionIndicator.hidden = YES;
            cell.backgroundColor = [UIColor whiteColor];
            [cell.menuPicto setImage:[UIImage imageNamed:@"picto-hairfie.png"]];
            cell.menuItem.text = [NSString stringWithFormat:@"© Hairfie 2015 v%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
            cell.menuPicto.layer.borderColor = [UIColor clearColor].CGColor;
            cell.indentationWidth = 0;
            cell.userInteractionEnabled = NO;

        }
    }
    if (indexPath.section == 0) {
        cell.backgroundColor = [UIColor whiteColor];
        cell.menuPicto.layer.borderColor = [UIColor clearColor].CGColor;
        cell.menuPicto.layer.cornerRadius = 0;
        cell.menuPicto.clipsToBounds = NO;
    }
    
    cell.menuItem.font = [UIFont fontWithName:@"SourceSansPro-Light" size:15];
    cell.menuItem.textColor = [UIColor colorWithRed:103/255.0f green:111/255.0f blue:116/255.0f alpha:1];
    cell.menuPicto.contentMode = UIViewContentModeScaleToFill;
    cell.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 3;
    if (section == 1)
        return 1 + [managedBusinesses count];
    else
        return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1)
        return 50;
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self performSegueWithIdentifier:@"HomeSegue" sender:self];
        } if (indexPath.row == 1) {
            [self deselectHomeCell:tableView];
            [self performSegueWithIdentifier:@"LikeSegue" sender:self];
        } if (indexPath.row == 2) {
            cell.selectionIndicator.hidden = NO;
            [self deselectHomeCell:tableView];
            [self performSegueWithIdentifier:@"FavoriteSegue" sender:self];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.selectionIndicator.hidden = NO;
            [self deselectHomeCell:tableView];
            [self performSegueWithIdentifier:@"BusinessSegue" sender:self];
        } if (indexPath.row <= [managedBusinesses count] && indexPath.row > 0) {
            cell.selectionIndicator.hidden = NO;
            //[self deselectHomeCell:tableView];
            businessToManage = [managedBusinesses objectAtIndex:indexPath.row - 1];
            [self performSegueWithIdentifier:@"ManageBusiness" sender:self];
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.selectionIndicator.hidden = NO;
            [self logOut];
            [self deselectHomeCell:tableView];
        }
    }
}

-(void)deselectHomeCell:(UITableView*)tableView {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    MenuTableViewCell *homeCell = (MenuTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    homeCell.selectionIndicator.hidden = YES;
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


-(IBAction)showUserProfile:(id)sender
{
    [self performSegueWithIdentifier:@"ProfileSegue" sender:self];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ManageBusiness"])
    {
        UINavigationController *navController = (UINavigationController*)[segue destinationViewController];
        FinalStepViewController *claimVc = [navController.viewControllers objectAtIndex:0];
        
        [claimVc setBusinessToManage:businessToManage];
     
    }
    if ([segue.identifier isEqualToString:@"ProfileSegue"])
    {
        
        UINavigationController *navController = (UINavigationController*)[segue destinationViewController];
        UserProfileViewController *userProfile = [navController.viewControllers objectAtIndex:0];
        
        [userProfile setUser:appDelegate.currentUser];
        userProfile.isCurrentUser = YES;
      //  userProfile.backgroundProfileImage = _profileImageView.image;
      //  userProfile.profileImage = profilePicture.image;
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
