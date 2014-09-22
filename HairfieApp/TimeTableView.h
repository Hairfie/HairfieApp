//
//  TimeTableView.h
//  HairfieApp
//
//  Created by Leo Martin on 22/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeTableView : UIView

@property (nonatomic) IBOutlet UILabel* dayLabel;
@property (nonatomic) IBOutlet UILabel* timeTableLabel;

-(void)setDayForTimetable:(NSString *)day;

-(void) settimeTableStringOpen:(NSString*)opening andClose:(NSString*)closing;


@end
