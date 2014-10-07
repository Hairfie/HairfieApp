//
//  TermsViewController.h
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 07/10/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TermsViewController : UIViewController <UINavigationControllerDelegate, UIWebViewDelegate>

@property (nonatomic) IBOutlet UIWebView *webView;

-(IBAction)goBack:(id)sender;

@end
