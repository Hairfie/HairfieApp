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

@interface MenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic) IBOutlet UITableView *menuTableView;
@property (nonatomic) IBOutlet UIView *profileView;
@property (nonatomic, strong) NSMutableArray *menuItems;
@property (nonatomic, strong) NSMutableArray *menuPictos;
@property (nonatomic) IBOutlet UILabel *name;
@property (nonatomic) IBOutlet UILabel *hairfieNb;
@property (nonatomic) User *currentUser;

- (IBAction)unwindToMenuViewController:(UIStoryboardSegue *)segue;
-(void) initCurrentUser;

@end