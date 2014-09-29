//
//  HorairesViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 18/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Timetable.h"

@interface HorairesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) IBOutlet UITableView *horaireTableView;
@property (nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;

@property (nonatomic) Timetable *timetable;

-(IBAction)goBack:(id)sender;

@end
