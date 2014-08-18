//
//  HairfieDetailCollectionReusableView.h
//  HairfieApp
//
//  Created by Leo Martin on 18/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HairfieDetailCollectionReusableView : UICollectionReusableView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UIImageView *hairfieImageView;
@property (nonatomic, strong) IBOutlet UITableView *infoTableView;
@property (nonatomic, strong) IBOutlet UITableView *commentTableView;

@property (nonatomic, strong) IBOutlet UIView *infoView;
@property (nonatomic, strong) IBOutlet UIView *hairfieView;

@property (nonatomic, strong) IBOutlet UIButton *addCommentBttn;
@property (nonatomic, strong) IBOutlet UIButton *moreCommentBttn;



@end
