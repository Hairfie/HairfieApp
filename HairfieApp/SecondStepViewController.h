//
//  SecondStepViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 16/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessClaim.h"

@interface SecondStepViewController : UIViewController <UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *topBarView;
@property (nonatomic) IBOutlet UIButton * nextBttn;
@property (nonatomic) IBOutlet UIButton * salonBttn;
@property (nonatomic) IBOutlet UIButton * phoneBttn;
@property (nonatomic) IBOutlet UITextField *salonTextField;
@property (nonatomic) IBOutlet UITextField *phoneTextField;
@property (nonatomic) IBOutlet UISegmentedControl *workType;
@property (nonatomic) IBOutlet UIImageView * manCutCheckBox;
@property (nonatomic) IBOutlet UIImageView * kidsCutCheckBox;
@property (nonatomic) IBOutlet UIImageView * womanCutCheckBox;
@property (nonatomic) IBOutlet UISegmentedControl *jobType;
@property (nonatomic) BusinessClaim *claim;
@property (nonatomic) BOOL isSalonSet;
@property (nonatomic) BOOL isPhoneSet;

@property (nonatomic) IBOutlet UILabel *manLbl;
@property (nonatomic) IBOutlet UILabel *womanLbl;
@property (nonatomic) IBOutlet UILabel *kidLbl;

-(IBAction)goBack:(id)sender;

@end
