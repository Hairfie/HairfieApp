//
//  FinalStepDescriptionViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 17/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinalStepDescriptionViewController : UIViewController <UINavigationControllerDelegate>

@property (nonatomic) IBOutlet UITextView *descriptionView;
@property (nonatomic) IBOutlet UIButton *doneBttn;
@property (nonatomic) NSString *desc;

@end
