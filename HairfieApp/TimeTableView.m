//
//  TimeTableView.m
//  HairfieApp
//
//  Created by Leo Martin on 22/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "TimeTableView.h"

@implementation TimeTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) settimeTableStringOpen:(NSString*)opening andClose:(NSString*)closing
{
    _timeTableLabel.text = [NSString stringWithFormat:@"%@h - %@h", opening, closing];
}

-(void)setDayForTimetable:(NSString *)day
{
    _dayLabel.text = day;
}

@end
