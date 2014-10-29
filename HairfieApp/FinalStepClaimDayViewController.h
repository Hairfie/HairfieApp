//
//  FinalStepClaimDayViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 17/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Day.h"

@interface FinalStepClaimDayViewController : UIViewController <UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic) NSString *headerString;
@property (nonatomic) IBOutlet UILabel *headerTitle;

@property (nonatomic) IBOutlet UIPickerView *closingTimePicker;
@property (nonatomic) IBOutlet UIPickerView *openingTimePicker;
@property (nonatomic) IBOutlet UIPickerView *dayPickerView;

@property (nonatomic) IBOutlet UIView* closingTimeView;
@property (nonatomic) IBOutlet UIView* openingTimeView;

@property (nonatomic) Day *dayPicked;
@property (nonatomic) NSString *openingTime;
@property (nonatomic) NSString *closingTime;

@property (nonatomic) IBOutlet UIButton *doneBttn;

@end
