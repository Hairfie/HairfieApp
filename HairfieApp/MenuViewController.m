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



@implementation MenuViewController

@synthesize menuTableView = _menuTableView;
@synthesize profileView = _profileView;
//@synthesize profilePictureView = _profilePictureView;
//@synthesize profilePicture = _profilePicture;


- (IBAction)unwindToMenuViewController:(UIStoryboardSegue *)segue {
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGesturePanning | ECSlidingViewControllerAnchoredGestureTapping;
    _menuTableView.backgroundColor = [UIColor clearColor];
    _menuTableView.opaque = NO;
    _menuTableView.backgroundView = nil;
    _menuTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _profileView.backgroundColor = [UIColor clearColor];
   
    UIImageView *profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(60, 50, 50, 50)];
    profilePicture.image = [UIImage imageNamed:@"leosquare.jpg"];
    
    profilePicture.layer.cornerRadius = profilePicture.frame.size.height / 2;
    profilePicture.clipsToBounds = YES;
    profilePicture.layer.borderWidth = 1.0f;
    profilePicture.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [_profileView addSubview:profilePicture];
    
    /*
    NSLog(@"%@", tost);
    
    if (tost != nil)
    {
        NSLog(@"COUCOU");
        
        _profilePictureView.image = _profilePicture;
 
    }
 
    _profilePictureView.layer.cornerRadius = _profilePictureView.frame.size.height / 2;
    _profilePictureView.clipsToBounds = YES;
    _profilePictureView.layer.borderWidth = 2.0f;
    _profilePictureView.layer.borderColor = [UIColor whiteColor].CGColor;
  //  profilePictureView.image = [[UIImage alloc] init];
   // profilePictureView.image = [UIImage imageWithContentsOfFile:@"leosquare.jpg"];
   */
   // [_profilePictureView setFrame:CGRectMake(18, 14, 100, 100)];
   // _profilePictureView.image = [UIImage imageNamed:@"leosquare.jpg"];
   // [_profilePictureView setImage:[UIImage imageNamed:@"leosquare.jpg"]];
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSInteger row = indexPath.row;
    
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    if (row == 0)
    {
        cell.textLabel.text =  [NSString  stringWithFormat:NSLocalizedString(@"Home", nil)];
    }
    else if (row == 1)
    {
        cell.textLabel.text =[NSString  stringWithFormat:NSLocalizedString(@"Favorites", nil)];
    }
    else if (row == 2)
    {
        cell.textLabel.text = [NSString  stringWithFormat:NSLocalizedString(@"Likes", nil)];
    }
    else if (row == 3)
    {
        cell.textLabel.text = [NSString  stringWithFormat:NSLocalizedString(@"Settings", nil)];
    }
    
    
    cell.selectedBackgroundView.bounds = CGRectMake(0, 0, 10, 44);
    cell.selectedBackgroundView.backgroundColor = [UIColor redColor];
    
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
    UITableViewCell *cell = [_menuTableView cellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"selected-cell.jpg"];
    NSInteger row = indexPath.row;

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
        [self performSegueWithIdentifier:@"SettingSegue" sender:self];
    }
}

-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [_menuTableView cellForRowAtIndexPath:indexPath];
    cell.imageView.image = nil;

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
