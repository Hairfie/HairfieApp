//
//  HairfiePostDetailsViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 09/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HairfiePostDetailsViewController : UIViewController <UINavigationControllerDelegate>

@property (nonatomic) IBOutlet UITextView *priceTextView;
@property (nonatomic) IBOutlet UIImageView *hairfieImageView;
@property (nonatomic) IBOutlet UITextField *emailTextField;

@property (nonatomic) UIImage *hairfie;



@end
