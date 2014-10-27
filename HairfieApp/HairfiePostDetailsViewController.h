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

@interface HairfiePostDetailsViewController : UIViewController <UINavigationControllerDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic) IBOutlet UIView *mainView;
@property (nonatomic) IBOutlet UIView *descView;
@property (nonatomic) IBOutlet UIView *topView;
@property (nonatomic) IBOutlet UITextField *priceTextField;
@property (nonatomic) IBOutlet UIButton *priceLabelButton;
@property (nonatomic) IBOutlet SAMTextView *hairfieDesc;
@property (nonatomic) IBOutlet UIImageView *hairfieImageView;
@property (nonatomic) IBOutlet UITextField *emailTextField;
@property (nonatomic) IBOutlet UITextField *whoTextField;
@property (nonatomic) IBOutlet UITableView *dataChoice;
@property (nonatomic) IBOutlet UILabel *salonLabel;
@property (nonatomic) IBOutlet UIButton *salonLabelButton;
@property (nonatomic) IBOutlet UIView *hairdresserSubview;
@property (nonatomic) IBOutlet UIView *priceSubview;
@property (nonatomic) IBOutlet NSLayoutConstraint *whoSubviewConstraint;
@property (nonatomic) IBOutlet UIView *emailSubview;
@property (nonatomic) IBOutlet UIButton *fbShareButton;

-(IBAction)fbShare:(id)sender;


@property (nonatomic) BOOL isSalon;
@property (nonatomic) BOOL isHairdresser;
@property (nonatomic) BOOL salonOrHairdresser;

@property (nonatomic) UIImage *hairfie;
@property (nonatomic) HairfiePost *hairfiePost;

@property (nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (nonatomic) IBOutlet NSLayoutConstraint *tableViewYPos;

@property (nonatomic) Business *salonChosen;

@end
