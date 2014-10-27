//
//  AddTagsToHairfieViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 10/27/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddTagsToHairfieViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) IBOutlet UIView *topView;
@property (nonatomic) IBOutlet UIButton *validateBttn;
@property (nonatomic) IBOutlet UITableView *tagsTableView;

@end
