//
//  DetailsCollectionViewCell.h
//  HairfieApp
//
//  Created by Leo Martin on 11/25/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Business.h"

@interface DetailsCollectionViewCell : UICollectionViewCell

@property (nonatomic) IBOutlet UILabel *businessName;
@property (nonatomic) IBOutlet UILabel *businessAddress;
@property (nonatomic) IBOutlet UIImageView *businessPicture;
@property (nonatomic) IBOutlet UILabel *workPlaceLbl;

@property (nonatomic, strong) Business *business;

@end
