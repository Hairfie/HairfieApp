//
//  ApplyFiltersViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 09/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Filters.h"

@interface ApplyFiltersViewController : UIViewController <UINavigationControllerDelegate>

@property (nonatomic) UIImage *hairfie;

@property (nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic) IBOutlet UIView *filtersView;


-(IBAction)sepia:(id)sender;
-(IBAction)newFilter:(id)sender;
-(IBAction)original:(id)sender;

@end
