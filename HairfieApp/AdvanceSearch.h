//
//  AdvanceSearch.h
//  HairfieApp
//
//  Created by Leo Martin on 02/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BusinessSearch.h"

@interface AdvanceSearch : UIView <UITextFieldDelegate>

@property (nonatomic) IBOutlet UITextField *searchByLocation;
@property (nonatomic) IBOutlet UITextField *searchByName;
@property (nonatomic) IBOutlet UIButton *searchAroundMe;
@property (nonatomic) IBOutlet UIButton *searchBttn;
@property (nonatomic) IBOutlet UIImageView *searchAroundMeImage;
@property (strong, nonatomic) BusinessSearch *businessSearch;

-(IBAction)searchAroundMe:(id)sender;
-(IBAction)cancelSearch:(id)sender;

-(void)initView;

@end
