//
//  PricesTableViewCell.h
//  HairfieApp
//
//  Created by Leo Martin on 21/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Service.h"

@interface PricesTableViewCell : UITableViewCell

@property (nonatomic) IBOutlet UILabel *itemName;
@property (nonatomic) IBOutlet UILabel *price;

-(void)updateWithPrice:(Service *)aPrice;

@end
