//
//  BusinessClaimExistingViewController.h
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 05/01/15.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessClaimExistingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *headerTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *headerSubmitButton;

@property (strong, nonatomic) Business *business;

@end
