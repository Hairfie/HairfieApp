//
//  BusinessHairdressersCollectionViewCell.h
//  HairfieApp
//
//  Created by Leo Martin on 11/24/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Hairdresser.h"

@interface BusinessHairdressersCollectionViewCell : UICollectionViewCell

@property (nonatomic) IBOutlet UILabel *hairdresserName;
@property (nonatomic) IBOutlet UIImageView *disclosureIndicator;

-(void)setHairdresser:(Hairdresser*)hairdresser;

@end
