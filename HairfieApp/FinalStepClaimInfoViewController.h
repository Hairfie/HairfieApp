//
//  FinalStepClaimInfoViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 2/11/15.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Address.h"
#import "Timetable.h"
@interface FinalStepClaimInfoViewController : UIViewController <UINavigationControllerDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>


@property (nonatomic) IBOutlet UILabel *headerLabel;
@property (nonatomic) IBOutlet UIButton *validateBttn;
@property (nonatomic) NSString *headerTitle;
@property (nonatomic) BOOL isTimetable;
@property (nonatomic) BOOL isAddress;
@property (nonatomic) BOOL isBusinessInfo;

// timetable
@property (nonatomic) IBOutlet UITableView *daysTableView;
@property (nonatomic) Timetable *timeTable;

//address
@property (nonatomic) IBOutlet UIView *addressContainerView;
@property (nonatomic) IBOutlet UITextField *street;
@property (nonatomic) IBOutlet UITextField *city;
@property (nonatomic) IBOutlet UITextField *zipCode;
@property (nonatomic) Address *address;
@property (nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

//business info
@property (nonatomic) IBOutlet UIView *businessInfoContainerView;
@property (nonatomic) IBOutlet UITextField *textField;
@property (nonatomic) NSString *textFieldPlaceHolder;
@property (nonatomic) NSString *textFieldFromSegue;
@property (nonatomic) BOOL isSalon;
@property (nonatomic) BOOL isExisting;
@property (nonatomic) BOOL isFinalStep;



@end
