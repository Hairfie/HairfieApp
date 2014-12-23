//
//  FavoriteViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 29/07/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriteViewController : UIViewController <UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) IBOutlet UIView *topView;
@property (nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) IBOutlet UILabel *headerTitle;

@property (nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;

@end
