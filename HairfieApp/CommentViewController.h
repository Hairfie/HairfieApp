//
//  CommentViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 20/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>


@property (nonatomic) IBOutlet UITableView *commentTableView;
@property (nonatomic) BOOL isCommenting;
@property (nonatomic) UIView *headerView;
@property (nonatomic) UITextView *commentTextView;
@property (nonatomic) UITapGestureRecognizer *dismiss;


-(IBAction)addComment:(id)sender;
-(IBAction)goBack:(id)sender;



@end
