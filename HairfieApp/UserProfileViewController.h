//
//  UserProfileViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 10/22/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface UserProfileViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate>


@property (nonatomic) IBOutlet UICollectionView *hairfiesCollection;
@property (nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic) BOOL isCurrentUser;
@property (nonatomic) IBOutlet UIView *topView;
@property (nonatomic) IBOutlet UITableView *reviewTableView;

@property (nonatomic) IBOutlet UIView *hairfieView;
@property (nonatomic) IBOutlet UIView *reviewView;

@property (nonatomic) IBOutlet UIImageView *backgroundProfilePicture;

@property (nonatomic) IBOutlet UIButton *hairfieBttn;
@property (nonatomic) IBOutlet UIButton *reviewBttn;
// Top View
@property (nonatomic) IBOutlet UILabel *userName;
@property (nonatomic) IBOutlet UILabel *reviewLbl;
@property (nonatomic) IBOutlet UIButton *followUserBttn;
@property (nonatomic) IBOutlet UIButton *leftMenuBttn;
@property (nonatomic) IBOutlet UIButton *navBttn;
@property (nonatomic) IBOutlet UIButton *bottomMenuBttn;

@property (nonatomic, strong) User *user;

@property (nonatomic) UIImage *backgroundProfileImage;
@property (nonatomic) UIImage *profileImage;

@property (nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (nonatomic) IBOutlet NSLayoutConstraint *mainViewHeight;
@property (nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;


@end
