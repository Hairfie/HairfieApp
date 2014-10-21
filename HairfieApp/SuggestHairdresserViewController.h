//
//  SuggestHairdresserViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 10/21/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuggestHairdresserViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic) IBOutlet UITextField *firstName;
@property (nonatomic) IBOutlet UIView *firstNameView;
@property (nonatomic) IBOutlet UITextField *lastName;
@property (nonatomic) IBOutlet UIView *lastNameView;
@property (nonatomic) IBOutlet UIButton *submitBttn;
@property (nonatomic) IBOutlet UILabel *headerTitle;


@end
