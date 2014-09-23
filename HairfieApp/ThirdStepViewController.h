//
//  ThirdStepViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 16/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessClaim.h"

@interface ThirdStepViewController : UIViewController <UINavigationControllerDelegate>



@property (nonatomic) IBOutlet UITextField *address;
@property (nonatomic) IBOutlet UITextField *city;
@property (nonatomic) IBOutlet UITextField *postalCode;
@property (nonatomic) IBOutlet UIButton *currentAddressBttn;
@property (nonatomic) IBOutlet UIButton *nextButton;
@property (nonatomic) BusinessClaim *claim;


@end

