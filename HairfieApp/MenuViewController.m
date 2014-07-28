//
//  MenuViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 28/07/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//


#import "MenuViewController.h"
#import "UIViewController+ECSlidingViewController.h"


@implementation MenuViewController

@synthesize menuTableView = _menuTableView;



- (IBAction)unwindToMenuViewController:(UIStoryboardSegue *)segue {
    NSLog(@"Open Menu");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGesturePanning | ECSlidingViewControllerAnchoredGestureTapping;
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
        cell.textLabel.text = @"Home";
    }
    else if (row == 1)
    {
        cell.textLabel.text = @"Favorites";
    }
    else if (row == 2)
    {
        cell.textLabel.text = @"Likes";
    }
    else if (row == 3)
    {
        cell.textLabel.text = @"Settings";
    }
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger row = indexPath.row;
    //
    if (row == 0)
    {
        NSLog(@"home");
    }
    
    if (row == 1)
    {
        NSLog(@"favorites");
    }
    if (row == 2)
    {
        NSLog(@"likes");
    }
    if (row == 3)
    {
        NSLog(@"settings");
    }
   // NSLog(@"%ld", indexPath.row);
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
