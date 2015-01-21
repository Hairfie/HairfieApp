//
//  BusinessMemberReusableView.h
//  HairfieApp
//
//  Created by Leo Martin on 11/25/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessMember.h"
#import "Business.h"

@interface BusinessMemberReusableView : UICollectionReusableView

@property (nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UIButton *hairfieBttn;
@property (nonatomic, strong) IBOutlet UIButton *detailsBttn;
@property (nonatomic) IBOutlet UIImageView *backgroundProfilePicture;
@property (nonatomic) IBOutlet UILabel *detailsLbl;
@property (nonatomic) IBOutlet UIButton *favoriteBttn;
@property (nonatomic) BusinessMember *businessMember;
@property (nonatomic) Business *business;
@property (nonatomic) NSInteger hairfiesCount;

-(void)setupView;
@end
