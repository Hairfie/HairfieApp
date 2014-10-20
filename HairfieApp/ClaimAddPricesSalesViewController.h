//
//  ClaimAddPricesSalesViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 22/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Service.h"
@interface ClaimAddPricesSalesViewController : UIViewController <UINavigationControllerDelegate, UITextFieldDelegate>

@property (nonatomic) IBOutlet UIView* priceDescriptionView;
@property (nonatomic) IBOutlet UITextField *priceDescription;
@property (nonatomic) IBOutlet UIView* priceValueView;
@property (nonatomic) IBOutlet UITextField *priceValue;
@property (nonatomic) IBOutlet UIButton* doneBttn;
@property (nonatomic) NSMutableArray *serviceClaimed;
@property (nonatomic) Service *serviceFromSegue;
@property (nonatomic) NSInteger serviceIndexFromSegue;

@end
