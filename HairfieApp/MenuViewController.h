//
//  MenuViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 28/07/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "User.h"
#import "Business.h"
#import "STCollapseTableView.h"

@interface MenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) IBOutlet STCollapseTableView *menuTableView;
@property (nonatomic) IBOutlet UIView *profileView;
@property (nonatomic) IBOutlet UIImageView *profileImageView;
@property (nonatomic, strong) NSMutableArray *menuItems;
@property (nonatomic, strong) NSMutableArray *menuPictos;
@property (nonatomic) IBOutlet UILabel *name;
@property (nonatomic) IBOutlet UILabel *hairfieNb;
@property (nonatomic) User *currentUser;

-(IBAction)unwindToMenuViewController:(UIStoryboardSegue *)segue;
-(void)initCurrentUser;

@end