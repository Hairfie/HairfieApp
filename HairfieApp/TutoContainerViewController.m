//
//  TutoContainerViewController.m
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 01/10/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "TutoContainerViewController.h"
#import "UserAuthenticator.h"
#import "AppDelegate.h"
#import "CredentialStore.h"
#import "LoginViewController.h"
#import "FBAuthenticator.h"
#import "MRProgress.h"


@interface TutoContainerViewController ()

@end

@implementation TutoContainerViewController {
    NSArray *pagesLabel;
    NSArray *imagesName;
    UserAuthenticator *userAuthenticator;
    FBAuthenticator *fbAuthenticator;
    AppDelegate *delegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pagesLabel = @[NSLocalizedStringFromTable(@"Find Haircuts & Hairstyles and take inspiration from people like you", @"Login_Sign_Up", nil), NSLocalizedStringFromTable(@"Find and book the Hairdresser you need. Anywhere. Anytime. ", @"Login_Sign_Up", nil), NSLocalizedStringFromTable(@"Keep & Share inspiring Hairfies", @"Login_Sign_Up", nil)];
    imagesName = @[@"tuto-page-1.png", @"tuto-page-2.png", @"tuto-page-3.png"];

    delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    userAuthenticator = [[UserAuthenticator alloc] init];
    fbAuthenticator   = [[FBAuthenticator alloc] init];
    


    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    TutoContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 0.75f);
    self.heightConstraint.constant = self.view.frame.size.height * 0.75f - 35;
    
    // Change the size of page view controller
    self.pageViewController.view.frame = frame;
    
    [self.view setBackgroundColor:[UIColor pinkHairfie]];

    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    _fbLogin.titleLabel.text = NSLocalizedStringFromTable(@"fbConnect", @"tuto", nil);
    _login.titleLabel.text = NSLocalizedStringFromTable(@"login", @"tuto", nil);
    _signUp.titleLabel.text = NSLocalizedStringFromTable(@"signUp", @"tuto", nil);
    [_fbLogin tutoStyle];
    [_login tutoStyle];
    [_signUp tutoStyle];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((TutoContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((TutoContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [pagesLabel count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (TutoContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([pagesLabel count] == 0) || (index >= [pagesLabel count])) {
        return nil;
    }
    
    TutoContentViewController *tutoContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TutoContentViewController"];
    tutoContentViewController.titleText = pagesLabel[index];
    tutoContentViewController.imageName = imagesName[index];
    tutoContentViewController.pageIndex = index;
    
    return tutoContentViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [pagesLabel count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

- (IBAction)getFacebookUserInfo:(id)sender {
    BOOL performLogin = ![delegate.credentialStore isLoggedIn];
    [MRProgressOverlayView showOverlayAddedTo:self.view title:NSLocalizedStringFromTable(@"Login in progress", @"Login_Sign_Up", nil) mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    
    [fbAuthenticator loginFbAccountWithPermissions:@[] allowUI:YES
                                           success:^{
                                               [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:YES];
                                               if(performLogin)    [self performSegueWithIdentifier:@"@Main" sender:self];
                                           }
                                           failure:^(NSError *error) {
                                               NSLog(@"Error : %@", error.description);
                                               [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:YES];
                                           }
     ];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"@Main#skip"]) {
        [userAuthenticator skipLogin];
    }
}

@end
