//
//  BusinessErrorReportViewController.h
//  HairfieApp
//
//  Created by Antoine Hérault on 29/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Business.h"

@interface BusinessErrorReportViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *headerTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *headerSubmitButton;
@property (weak, nonatomic) IBOutlet UITextView *bodyText;

@property (strong, nonatomic) Business *business;

@end
