//
//  FirstStepViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 16/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessClaim.h"

@interface FirstStepViewController : UIViewController <UINavigationControllerDelegate>

@property (nonatomic) IBOutlet UIButton * salonBttn;
@property (nonatomic) IBOutlet UIButton * homeBttn;
@property (nonatomic) BusinessClaim *claim;

@end
