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

@property (nonatomic) IBOutlet UIButton * nextBttn;
@property (nonatomic) IBOutlet UIButton * salonBttn;
@property (nonatomic) IBOutlet UIButton * phoneBttn;
@property (nonatomic) IBOutlet UISegmentedControl *workType;
@property (nonatomic) IBOutlet UIImageView * manCutCheckBox;
@property (nonatomic) IBOutlet UIImageView * kidsCutCheckBox;
@property (nonatomic) IBOutlet UIImageView * womanCutCheckBox;
@property (nonatomic) IBOutlet UISegmentedControl *jobType;
@property (nonatomic) BusinessClaim *claim;
-(IBAction)goBack:(id)sender;

@end
