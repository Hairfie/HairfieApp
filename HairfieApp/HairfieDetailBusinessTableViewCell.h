//
//  HairfieDetailBusinessTableViewCell.h
//  HairfieApp
//
//  Created by Antoine Hérault on 05/11/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Business.h"

@interface HairfieDetailBusinessTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *streetAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UIButton *bookButton;

@property (strong, nonatomic) Business *business;

-(void)setBusiness:(Business *)aBusiness;

-(IBAction)book:(id)sender;

@end
