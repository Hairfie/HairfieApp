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

@property (weak, nonatomic) IBOutlet UILabel *alreadyClaimedLabel;
@property (weak, nonatomic) IBOutlet UILabel *claimTitleLabel;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIWebView *webView;



@property (strong, nonatomic) Business *business;

@end
