//
//  UserProfileReusableView.h
//  HairfieApp
//
//  Created by Leo Martin on 11/19/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface UserProfileReusableView : UICollectionReusableView

@property (nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UIButton *hairfieBttn;
@property (nonatomic, strong) IBOutlet UIButton *reviewBttn;
@property (nonatomic) IBOutlet UIImageView *backgroundProfilePicture;
@property (nonatomic) IBOutlet UILabel *reviewLbl;
@property (nonatomic) User * user;

@property (nonatomic) IBOutlet UIButton *editPictureBttn;


-(void)setButtonSelected:(UIButton*)aButton;
-(void)setupView;
-(void)setupHeaderPictures;
-(void)setupData;

@end
