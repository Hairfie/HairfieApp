//
//  HairfiePostSalonTypeViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 10/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HairfiePostSalonTypeViewController : UIViewController <UINavigationControllerDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) IBOutlet UITextField *searchByName;
@property (nonatomic) IBOutlet UITextField *searchByLocation;
@property (nonatomic) IBOutlet UIButton *searchAroundMe;
@property (nonatomic) IBOutlet UIImageView *searchAroundMeImage;
@property (nonatomic) IBOutlet UIButton *searchBttn;

@property (nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;

@end
