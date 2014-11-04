//
//  PostHairfieEmailViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 11/3/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "HairfiePost.h"
#import <UIKit/UIKit.h>

@interface PostHairfieEmailViewController : UIViewController <UINavigationControllerDelegate, UITextFieldDelegate>


@property (nonatomic) IBOutlet UITextField *emailField;
@property (nonatomic) IBOutlet UILabel *headerTitle;
@property (nonatomic) IBOutlet UIButton *validateBttn;
@property (nonatomic) HairfiePost *hairfiePost;
@end
