//
//  HairfieDetailViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 11/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HairfieDetailViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource>


@property (nonatomic) IBOutlet UIScrollView *myScrollView;
@property (nonatomic) IBOutlet UIImageView *hairfieImageView;
@property (nonatomic) IBOutlet UITableView *infoTableView;
@property (nonatomic) IBOutlet UITableView *commentTableView;

@property (nonatomic) IBOutlet UIView *infoView;
@property (nonatomic) IBOutlet UIView *hairfieView;

@property (nonatomic) IBOutlet UIButton *addCommentBttn;
@property (nonatomic) IBOutlet UIButton *moreCommentBttn;

@property (nonatomic) IBOutlet UICollectionView *hairfieCollection;
@property (nonatomic) IBOutlet UICollectionReusableView *test;

-(IBAction)goBack:(id)sender;

@end
