//
//  SearchFilterViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 1/19/15.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BusinessSearch.h"


// Declaration du delegate

@protocol SearchFilterDelegate <NSObject>

@optional

- (void)didSetABusinessSearch:(BusinessSearch*)aBusinessSearch;
@end

#import "AroundMeViewController.h"



@interface SearchFilterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>


// variable delegate

@property (nonatomic) id<SearchFilterDelegate> myDelegate;

@property (nonatomic) IBOutlet UILabel *topBarTitle;

@property (nonatomic) IBOutlet UITextField *searchTextField;
@property (nonatomic) IBOutlet UITextField *locationTextField;

@property (nonatomic) IBOutlet UITableView *searchFiltersTable;

@property (nonatomic) BusinessSearch *businessSearch;

@property (nonatomic) BOOL isModifyingSearch;

@end
