//
//  FinalStepAddressViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 17/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinalStepAddressViewController : UIViewController <UINavigationControllerDelegate>


@property (nonatomic) IBOutlet UITextField *address;
@property (nonatomic) IBOutlet UITextField *city;
@property (nonatomic) IBOutlet UITextField *country;
@property (nonatomic) IBOutlet UIButton *doneBttn;

@end