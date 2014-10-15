//
//  ApplyFiltersViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 09/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Filters.h"
#import "HairfiePost.h"

@interface ApplyFiltersViewController : UIViewController <UINavigationControllerDelegate>

@property (nonatomic) HairfiePost *hairfiePost;

@property (nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic) IBOutlet UIView *filtersView;


@property (nonatomic) IBOutlet UIButton *nextBttn;

-(IBAction)sepia:(id)sender;
-(IBAction)newFilter:(id)sender;
-(IBAction)original:(id)sender;

@property (nonatomic) IBOutlet UIButton *originalBttn;
@property (nonatomic) IBOutlet UIButton *sepiaBttn;
@property (nonatomic) IBOutlet UIButton *curveBttn;


@end
