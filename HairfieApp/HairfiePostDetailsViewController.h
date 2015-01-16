//
//  HairfiePostDetailsViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 09/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAMTextView.h"
#import "Business.h"
#import "HairfiePost.h"
#import "Hairdresser.h"

@interface HairfiePostDetailsViewController : UIViewController <UINavigationControllerDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic) IBOutlet UIView *mainView;
@property (nonatomic) IBOutlet UIView *descView;
@property (nonatomic) IBOutlet UIView *topView;
@property (nonatomic) IBOutlet UIView *containerView;
@property (nonatomic) IBOutlet UITextField *priceTextField;
@property (nonatomic) IBOutlet UIButton *priceLabelButton;
@property (nonatomic) IBOutlet SAMTextView *hairfieDesc;
@property (nonatomic) IBOutlet UIImageView *hairfieImageView;
@property (nonatomic) IBOutlet UIImageView *secondHairfieImageView;

@property (nonatomic) IBOutlet UITextField *emailTextField;
@property (nonatomic) IBOutlet UITextField *whoTextField;
@property (nonatomic) IBOutlet UITableView *dataChoice;
@property (nonatomic) IBOutlet UITableView *hairdresserTableView;
@property (nonatomic) IBOutlet UILabel *salonLabel;
@property (nonatomic) IBOutlet UIButton *salonLabelButton;
@property (nonatomic) IBOutlet UIButton *hairdresserLabelButton;
@property (nonatomic) IBOutlet UIView *hairdresserSubview;
@property (nonatomic) IBOutlet UIView *priceSubview;
@property (nonatomic) IBOutlet NSLayoutConstraint *whoSubviewConstraint;
@property (nonatomic) IBOutlet UIView *emailSubview;
@property (nonatomic) IBOutlet UIButton *facebookShareButton;
@property (nonatomic) IBOutlet UIButton *facebookPageShareButton;
@property (nonatomic) IBOutlet UIButton *twitterShareButton;
@property (nonatomic) IBOutlet UILabel *emailLabel;
@property (nonatomic) IBOutlet UIButton *tagsButton;
-(IBAction)fbShare:(id)sender;


@property (nonatomic) BOOL isSalon;
@property (nonatomic) BOOL isHairdresser;
@property (nonatomic) BOOL salonOrHairdresser;

@property (nonatomic) UIImage *hairfie;
@property (nonatomic) HairfiePost *hairfiePost;

@property (nonatomic) IBOutlet NSLayoutConstraint *salonTableViewHeight;
@property (nonatomic) IBOutlet NSLayoutConstraint *hairdresserTableViewHeight;
@property (nonatomic) IBOutlet NSLayoutConstraint *tableViewYPos;
@property (nonatomic) IBOutlet NSLayoutConstraint *shareViewYPos;

@property (nonatomic) Business *salonChosen;
@property (nonatomic) Hairdresser *hairdresserChosen;



@end
