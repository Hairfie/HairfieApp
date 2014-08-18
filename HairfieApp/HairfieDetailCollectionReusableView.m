//
//  HairfieDetailCollectionReusableView.m
//  HairfieApp
//
//  Created by Leo Martin on 18/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "HairfieDetailCollectionReusableView.h"
#import "CommentTableViewCell.h"
#import "HairfieDetailTableViewCell.h"

@implementation HairfieDetailCollectionReusableView

@synthesize infoTableView = _infoTableView, hairfieImageView = _hairfieImageView, commentTableView = _commentTableView, addCommentBttn = _addCommentBttn, moreCommentBttn = _moreCommentBttn;

- (void)awakeFromNib {
    
    _hairfieView = [[UIImageView alloc]init];
    _infoTableView.backgroundColor = [UIColor clearColor];
    _hairfieImageView.clipsToBounds = YES;
    _infoTableView.scrollEnabled = NO;
    _addCommentBttn.layer.cornerRadius = 5;
    _addCommentBttn.layer.masksToBounds = YES;
    _commentTableView.backgroundColor = [UIColor clearColor];
    _moreCommentBttn.layer.cornerRadius = 5;
    _moreCommentBttn.layer.masksToBounds = YES;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _infoTableView)
        return 3;
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _commentTableView)
        return 130;
    return 43;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _infoTableView)
    {
        static NSString *CellIdentifier = @"infoCell";
        HairfieDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HairfieDetailTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        _infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, 1024, 1)];
        separatorView.layer.borderColor = [UIColor colorWithRed:236/255.0f green:237/255.0f  blue:237/255.0f  alpha:1].CGColor;
        separatorView.layer.borderWidth = 1.0;
        [cell.contentView addSubview:separatorView];
        
        if (indexPath.row == 0)
        {
            cell.pictoView.image = [UIImage imageNamed:@"picto-hairfie-detail-hairdresser.png"];
            cell.contentLabel.text = @"Franck Provost, 75002 Paris";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
        if (indexPath.row == 1)
        {
            cell.pictoView.image = [UIImage imageNamed:@"picto-hairfie-detail-employee.png"];
            cell.contentLabel.text = @"Kimi Smith";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.row == 2)
        {
            cell.pictoView.image = [UIImage imageNamed:@"picto-hairfie-detail-price.png"];
            cell.contentLabel.text = @"$ 40";
        }
        
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"commentCell";
        CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        return cell;
    }
    return nil;
}



@end
