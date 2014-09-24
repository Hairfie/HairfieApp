//
//  FinalStepAddressViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 17/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Address.h"
@interface FinalStepAddressViewController : UIViewController <UINavigationControllerDelegate, UITextFieldDelegate>


@property (nonatomic) IBOutlet UITextField *street;
@property (nonatomic) IBOutlet UITextField *city;
@property (nonatomic) IBOutlet UITextField *country;
@property (nonatomic) IBOutlet UIButton *doneBttn;
@property (nonatomic) Address *address;

@end
