//
//  FinalStepTimetableViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 17/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Timetable.h"

@interface FinalStepTimetableViewController : UIViewController <UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>


@property (nonatomic) IBOutlet UIButton *doneBttn;

@property (nonatomic) Timetable *timeTable;

@property (nonatomic) IBOutlet UITableView *timeTableView;


@end
