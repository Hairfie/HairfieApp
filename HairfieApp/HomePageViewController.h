//
//  HomePageViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 1/7/15.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKPickerView.h"

@interface HomePageViewController : UIViewController <AKPickerViewDataSource, AKPickerViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) AKPickerView *pickerView;

@end
