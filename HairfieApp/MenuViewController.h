//
//  MenuViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 28/07/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic) IBOutlet UITableView *menuTableView;
@property (nonatomic) IBOutlet UIView *profileView;
@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) NSMutableArray *menuPictos;

- (IBAction)unwindToMenuViewController:(UIStoryboardSegue *)segue;

@end