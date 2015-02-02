//
//  UserProfileViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 11/19/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface UserProfileViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIActionSheetDelegate>

@property (nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) User * user;

@property (nonatomic) BOOL isCurrentUser;

@property (nonatomic) IBOutlet UIButton *navBttn;
@property (nonatomic) IBOutlet UIButton *leftMenuBttn;

@property (nonatomic) UIImage *imageFromSegue;




@end
