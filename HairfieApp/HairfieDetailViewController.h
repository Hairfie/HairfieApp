//
//  HairfieDetailViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 11/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "Hairfie.h"

@interface HairfieDetailViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) IBOutlet UILabel *headerTitleLabel;
@property (nonatomic) IBOutlet UICollectionView *hairfieCollection;
@property (nonatomic) IBOutlet UIView *topBarView;
@property (nonatomic) Hairfie *hairfie;
@property (nonatomic) UIImage *hairfieImage;



-(IBAction)goBack:(id)sender;

@end
