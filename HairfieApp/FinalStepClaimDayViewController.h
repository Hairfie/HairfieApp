//
//  FinalStepClaimDayViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 17/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinalStepClaimDayViewController : UIViewController <UINavigationControllerDelegate>

@property (nonatomic) NSString *headerString;
@property (nonatomic) IBOutlet UILabel *headerTitle;

@property (nonatomic) IBOutlet UIButton *openingTime;
@property (nonatomic) IBOutlet UIButton *closingTime;

@property (nonatomic) IBOutlet UIButton *doneBttn;

@end
