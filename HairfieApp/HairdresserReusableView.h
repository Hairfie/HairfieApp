//
//  HairdresserReusableView.h
//  HairfieApp
//
//  Created by Leo Martin on 11/25/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Hairdresser.h"
#import "Business.h"

@interface HairdresserReusableView : UICollectionReusableView

@property (nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UIButton *hairfieBttn;
@property (nonatomic, strong) IBOutlet UIButton *detailsBttn;
@property (nonatomic) IBOutlet UIImageView *backgroundProfilePicture;
@property (nonatomic) IBOutlet UILabel *detailsLbl;
@property (nonatomic) Hairdresser *hairdresser;
@property (nonatomic) Business *business;
@property (nonatomic) NSInteger hairfiesCount;

-(void)setupView;
@end
