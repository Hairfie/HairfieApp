//
//  testViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 30/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STCollapseTableView.h"

@interface testViewController : UIViewController <UINavigationControllerDelegate>

@property (nonatomic, strong) NSMutableArray *menuItems;
@property (nonatomic, strong) NSMutableArray *menuPictos;
@property (nonatomic) IBOutlet STCollapseTableView *menuTableView;

@end
