//
//  ClaimAddServicesViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 22/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Service.h"
@interface ClaimAddServicesViewController : UIViewController <UINavigationControllerDelegate, UITextFieldDelegate>


@property (nonatomic) IBOutlet UITextField *serviceDescription;
@property (nonatomic) IBOutlet UITextField *serviceValue;
@property (nonatomic) IBOutlet UITextField *serviceDuration;

@property (nonatomic) IBOutlet UILabel* titleLabel;
@property (nonatomic) IBOutlet UIButton* doneBttn;
@property (nonatomic) NSMutableArray *serviceClaimed;
@property (nonatomic) Service *serviceFromSegue;
@property (nonatomic) NSInteger serviceIndexFromSegue;
@property (nonatomic) NSString *businessId;

@end
