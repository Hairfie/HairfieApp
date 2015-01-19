//
//  SearchFilterTableViewCell.h
//  HairfieApp
//
//  Created by Leo Martin on 1/19/15.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchFilterTableViewCell : UITableViewCell

@property (nonatomic) IBOutlet UIButton *activateBttn;
@property (nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic) BOOL isSelected;
@end
