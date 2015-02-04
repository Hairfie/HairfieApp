//
//  FavoriteCell.h
//  HairfieApp
//
//  Created by Leo Martin on 12/9/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIRoundImageView.h"
#import "BusinessMember.h"

@interface FavoriteCell : UITableViewCell

@property (nonatomic) IBOutlet UIButton *hairdresserName;
@property (nonatomic) IBOutlet UIButton *hairdresserBusiness;
@property (nonatomic) IBOutlet UILabel *hairdresserHairfies;
@property (nonatomic) IBOutlet UIRoundImageView *hairdresserPicture;

@property (nonatomic) IBOutlet NSLayoutConstraint *businessWidth;

@property (strong, nonatomic) BusinessMember *businessMember;

@end

