//
//  SecondStepSalonPhoneViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 16/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondStepSalonPhoneViewController : UIViewController < UINavigationControllerDelegate, UITextFieldDelegate >


@property (nonatomic) IBOutlet UIButton *doneBttn;;
@property (nonatomic) IBOutlet UILabel *headerLabel;
@property (nonatomic)  IBOutlet UITextField *textField;

@property (nonatomic) NSString *headerTitle;
@property (nonatomic) NSString *textFieldPlaceHolder;
@property (nonatomic) NSString *textFieldFromSegue;
@property (nonatomic) BOOL isSalon;
@property (nonatomic) BOOL isExisting;
@property (nonatomic) BOOL isFinalStep;

@end
