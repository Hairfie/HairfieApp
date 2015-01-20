//
//  BusinessMemberViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 11/25/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessMember.h"
#import "Business.h"

@interface BusinessMemberViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) BusinessMember *businessMember;
@property (nonatomic) Business *business;

@end
