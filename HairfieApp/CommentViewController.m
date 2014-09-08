//
//  CommentViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 20/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentTableViewCell.h"

@interface CommentViewController ()

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupHeaderView];
    _dismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
}

-(void) viewWillAppear:(BOOL)animated
{
    if (_isCommenting == YES)
    {
        [_commentTextView becomeFirstResponder];
        _commentTableView.scrollEnabled = NO;
        _commentTextView.text = @"";
        [_commentTableView reloadData];
    }
   else _commentTableView.scrollEnabled = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) setupHeaderView;
{
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 210)];
    _headerView.backgroundColor = [UIColor whiteColor];
    UIView *frontView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 200)];

    _commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 10, 280, 176)];
    _commentTextView.delegate = self;
    _commentTextView.backgroundColor = [UIColor clearColor];
    _commentTextView.text = @"Ajoutez votre commentaire...";
    _commentTextView.textColor = [[UIColor blackHairfie] colorWithAlphaComponent:0.6];
    _commentTextView.returnKeyType = UIReturnKeyDone;


    frontView.backgroundColor = [UIColor colorWithRed:50/255.0f green:67/255.0f blue:87/255.0f alpha:0.1];
    frontView.layer.cornerRadius = 5;
    frontView.layer.masksToBounds = YES;

    [_headerView addSubview:frontView];

    [frontView addSubview:_commentTextView];
}

-(void) hideKeyboard
{

    [_commentTextView resignFirstResponder];
    _isCommenting = NO;
    _commentTableView.scrollEnabled = YES;
    [_commentTableView reloadData];
}

-(IBAction)addComment:(id)sender
{

    [_commentTextView becomeFirstResponder];
    if (_isCommenting == NO)
    {
        _isCommenting = YES;
        _commentTableView.scrollEnabled = NO;
    }
    [_commentTableView reloadData];
}

// Text View Delegate

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text = @"";
    [textView becomeFirstResponder];
    [self.view addGestureRecognizer:_dismiss];

}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    return YES;
}

- (BOOL) textView: (UITextView*) textView
shouldChangeTextInRange: (NSRange) range
  replacementText: (NSString*) text
{
    if ([text isEqualToString:@"\n"]) {

        _isCommenting = NO;

        _commentTableView.scrollEnabled = YES;
        _commentTextView.text = @"Ajoutez votre commentaire...";
        [_commentTableView reloadData];
        [textView resignFirstResponder];

        return NO;
    }
    _commentTableView.scrollEnabled = NO;
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""])
    {
        _isCommenting = YES;
        textView.text = @"Ajoutez votre commentaire...";
        _commentTableView.scrollEnabled = NO;
    }
    else
    {
        NSString *contentComment = textView.text;
        _isCommenting = NO;

        [_commentTableView reloadData];
        _commentTableView.scrollEnabled = YES;
    }

    [textView resignFirstResponder];
    [self.view removeGestureRecognizer:_dismiss];


}



// Table View Delegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _headerView;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_isCommenting)
        return 210;
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"commentCell";
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.backgroundColor = [UIColor whiteColor];

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
