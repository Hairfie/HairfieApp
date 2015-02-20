//
//  ImageSetPicker.h
//  HairfieApp
//
//  Created by Antoine Hérault on 20/02/2015.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraViewController.h"

@protocol ImageSetPickerDelegate;

@interface ImageSetPicker : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, CameraViewControllerDelegate>

@property (nonatomic, assign) id <ImageSetPickerDelegate> delegate;

@property (nonatomic, strong) IBOutlet UICollectionView *imagesCollection;
@property (nonatomic, strong) IBOutlet UIButton *validateButton;
@property (nonatomic, strong) IBOutlet UIImageView *previewImage;
@property (nonatomic, strong) IBOutlet UICollectionView *filtersCollection;

@property (nonatomic, strong) NSArray *images;
@property (nonatomic) NSInteger previewedImageIndex;

+(ImageSetPicker *)setup:(UIViewController *)vc;
+(void)remove:(ImageSetPicker *)picker;

@end

@protocol ImageSetPickerDelegate

-(void)imageSetPicker:(ImageSetPicker *)imageSetPicker didReturnWithImages:(NSArray *)images;

-(void)imageSetPickerDidCancel:(ImageSetPicker *)imageSetPicker;

-(NSInteger)imageSetPickerMaximumImageCount:(ImageSetPicker *)imageSetPicker;

-(NSInteger)imageSetPickerMinimumImageCount:(ImageSetPicker *)imageSetPicker;

@end