//
//  TutoContainerViewController.h
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 01/10/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TutoContentViewController.h"
#import "UIButton+Style.h"


@interface TutoContainerViewController : UIViewController  <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;

@property (nonatomic) IBOutlet UIButton *fbLogin;
@property (nonatomic) IBOutlet UIButton *login;
@property (nonatomic) IBOutlet UIButton *signUp;
@property (nonatomic) IBOutlet UIView   *bgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;


- (IBAction)getFacebookUserInfo:(id)sender;


@end
