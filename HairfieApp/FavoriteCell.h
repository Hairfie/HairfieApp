//
//  FavoriteCell.h
//  HairfieApp
//
//  Created by Leo Martin on 12/9/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIRoundImageView.h"
#import "Hairdresser.h"

@interface FavoriteCell : UITableViewCell

@property (nonatomic) IBOutlet UIButton *hairdresserName;
@property (nonatomic) IBOutlet UIButton *hairdresserBusiness;
@property (nonatomic) IBOutlet UILabel *hairdresserHairfies;

@property (nonatomic) IBOutlet NSLayoutConstraint *businessWidth;

-(void)setupCell:(Hairdresser*)hairdresser;

@end

