//
//  SignUpViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 26/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController <UITableViewDelegate>

@property (nonatomic) IBOutlet UIButton *signUpButton;
@property (nonatomic) IBOutlet UIButton *statusBarButton;
@property (nonatomic) IBOutlet UIView *infoView;
@property (nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic) IBOutlet UIButton *checkBoxButton;
@property (nonatomic) BOOL isChecked;

-(IBAction)goBack:(id)sender;
-(IBAction)checkBox:(id)sender;

@end
