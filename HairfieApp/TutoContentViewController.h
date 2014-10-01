//
//  TutoContentViewController.h
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 01/10/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutoContentViewController : UIViewController

@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *imageName;


@property (nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic) IBOutlet UIImageView *imageView;


@end
