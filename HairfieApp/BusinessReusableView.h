//
//  BusinessReusableView.h
//  HairfieApp
//
//  Created by Leo Martin on 11/24/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessReusableView : UICollectionReusableView

@property (nonatomic, strong) IBOutlet UIButton *hairfiesBttn;
@property (nonatomic, strong) IBOutlet UIButton *detailsBttn;
@property (nonatomic, strong) IBOutlet UIButton *hairdressersBttn;
@property (nonatomic, strong) IBOutlet UIButton *servicesBttn;

-(void)setupView;

@end
