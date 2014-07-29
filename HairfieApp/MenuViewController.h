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

- (IBAction)unwindToMenuViewController:(UIStoryboardSegue *)segue;

@end