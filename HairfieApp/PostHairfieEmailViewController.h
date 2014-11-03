//
//  PostHairfieEmailViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 11/3/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostHairfieEmailViewController : UIViewController <UINavigationControllerDelegate, UITextFieldDelegate>


@property (nonatomic) IBOutlet UITextField *emailField;
@property (nonatomic) IBOutlet UILabel *headerTitle;

@end
