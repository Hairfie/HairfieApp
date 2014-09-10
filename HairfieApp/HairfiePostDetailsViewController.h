//
//  HairfiePostDetailsViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 09/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HairfiePostDetailsViewController : UIViewController <UINavigationControllerDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic) IBOutlet UITextField *priceTextField;
@property (nonatomic) IBOutlet UITextView *hairfieDesc;
@property (nonatomic) IBOutlet UIImageView *hairfieImageView;
@property (nonatomic) IBOutlet UITextField *emailTextField;
@property (nonatomic) IBOutlet UITableView *dataChoice;
@property (nonatomic) IBOutlet UILabel *salonLabel;
@property (nonatomic) BOOL isSalon;
@property (nonatomic) BOOL isHairdresser;
@property (nonatomic) BOOL salonOrHairdresser;

@property (nonatomic) UIImage *hairfie;

@property (nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (nonatomic) IBOutlet NSLayoutConstraint *tableViewYPos;

@property (nonatomic) NSDictionary *salonChosen;

@end
