//
//  ClaimServiceTableViewCell.h
//  HairfieApp
//
//  Created by Leo Martin on 10/20/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClaimServiceTableViewCell : UITableViewCell

@property (nonatomic) IBOutlet UILabel *serviceName;
@property (nonatomic) IBOutlet UILabel *serviceAmount;
@property (nonatomic) IBOutlet UIButton *clearBttn;

@end
