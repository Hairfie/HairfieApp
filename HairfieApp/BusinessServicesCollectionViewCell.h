//
//  BusinessServicesCollectionViewCell.h
//  HairfieApp
//
//  Created by Leo Martin on 11/24/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Service.h"

@interface BusinessServicesCollectionViewCell : UICollectionViewCell

@property (nonatomic) IBOutlet UILabel *serviceName;
@property (nonatomic) IBOutlet UILabel *servicePrice;

-(void)setService:(Service*)service;

@end
