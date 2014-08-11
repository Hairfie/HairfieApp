//
//  HairfieDetailViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 11/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "HairfieDetailViewController.h"
#import "HairfieDetailTableViewCell.h"
#import "CommentTableViewCell.h"
#import "CustomCollectionViewCell.h"

@interface HairfieDetailViewController ()

@end

@implementation HairfieDetailViewController

@synthesize myScrollView = _myScrollView, infoTableView = _infoTableView, hairfieImageView = _hairfieImageView, commentTableView = _commentTableView, addCommentBttn = _addCommentBttn, moreCommentBttn = _moreCommentBttn;

- (void)viewDidLoad {
    [super viewDidLoad];
    _infoTableView.backgroundColor = [UIColor clearColor];
    _myScrollView.contentSize = CGSizeMake(320, 2320);
    _hairfieImageView.clipsToBounds = YES;
    
    _infoTableView.scrollEnabled = NO;
    _hairfieCollection.delegate = self;
    _hairfieCollection.dataSource = self;
    _addCommentBttn.layer.cornerRadius = 5;
    _addCommentBttn.layer.masksToBounds = YES;
     _moreCommentBttn.layer.cornerRadius = 5;
    _moreCommentBttn.layer.masksToBounds = YES;
      [_hairfieCollection registerNib:[UINib nibWithNibName:@"CustomCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"hairfieRelated"];
//[_hairfieCollection setFrame:CGRectMake(0, 601, 320, 800)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addGradientToView:(UIView *)view
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = @[(id)[[UIColor clearColor] CGColor],
                        (id)[[UIColor blackColor] CGColor]];
    [view.layer insertSublayer:gradient atIndex:0];
}


-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HairfieDetailTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
    
     _infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.backgroundColor = [UIColor clearColor];
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
         return cell;
   }
    if (tableView == _commentTableView)
    {
        static NSString *CellIdentifier = @"commentCell";
        CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        return cell;
    }
    
     _myScrollView.contentSize = CGSizeMake(320, _hairfieCollection.frame.origin.y + _hairfieCollection.frame.size.height);
    
    return nil;
}

// Collection View delegate


- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return 4;
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}


// 3
- (CustomCollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
      static NSString *CellIdentifier = @"hairfieRelated";
    CustomCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCollectionViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.name.text = @"Kimi Smith";
    cell.hairfieView.image = [UIImage imageNamed:@"hairfie.jpg"];
    cell.layer.borderColor = [UIColor colorWithRed:234/255.0f green:236/255.0f blue:238/255.0f alpha:1].CGColor;
    cell.layer.borderWidth = 1.0f;
    return cell;
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
