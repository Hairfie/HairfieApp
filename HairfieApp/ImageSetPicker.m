//
//  ImageSetPicker.m
//  HairfieApp
//
//  Created by Antoine Hérault on 20/02/2015.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import "ImageSetPicker.h"
#import "ImageSetPickerImageCell.h"
#import "ImageSetPickerFilterCell.h"
#import "CameraViewController.h"

#define IMAGE_KEY_RAW @"raw"
#define IMAGE_KEY_FILTERED @"filtered"

#define CELL_FILTER @"filter"
#define CELL_IMAGE @"image"
#define CELL_IMAGE_ADD @"image-add"

static void * ImageSetContext = &ImageSetContext;
static void * ImagePreviewContext = &ImagePreviewContext;

@interface ImageSetPicker ()

@end

@implementation ImageSetPicker
{
    NSArray *filters;
    CameraViewController *cameraViewController;
}

+(ImageSetPicker *)setup:(UIViewController<ImageSetPickerDelegate> *)vc
{
    ImageSetPicker *picker = [[ImageSetPicker alloc] initWithNibName:@"ImageSetPicker" bundle:nil];
    picker.delegate = vc;
    [vc addChildViewController:picker];
    picker.view.frame = vc.view.frame;
    [vc.view addSubview:picker.view];
    [picker didMoveToParentViewController:vc];
    
    return picker;
}

+(void)remove:(ImageSetPicker *)picker
{
    [picker.view removeFromSuperview];
    [picker removeFromParentViewController];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.images = [[NSArray alloc] init];
    
    filters = @[@"original", @"sepia", @"curve", @"transfer", @"instant", @"process", @"black-white", @"vignette", @"vintage"];
    
    [self.imagesCollection registerNib:[UINib nibWithNibName:@"ImageSetPickerImageCell" bundle:nil] forCellWithReuseIdentifier:CELL_IMAGE];
    [self.filtersCollection registerNib:[UINib nibWithNibName:@"ImageSetPickerFilterCell" bundle:nil] forCellWithReuseIdentifier:CELL_FILTER];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self addObserver:self forKeyPath:@"images" options:NSKeyValueObservingOptionNew context:ImageSetContext];
    [self addObserver:self forKeyPath:@"previewedImageIndex" options:NSKeyValueObservingOptionNew context:ImagePreviewContext];
    
    self.images = self.images;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self removeObserver:self forKeyPath:@"images"];
    [self removeObserver:self forKeyPath:@"previewedImageIndex"];
    
    [super viewWillDisappear:animated];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == ImageSetContext) {
        [self.imagesCollection reloadData];
        self.validateButton.hidden = ![self canValidate];
        self.previewedImageIndex = self.images.count - 1;
        
        if (self.images.count < 1) {
            [self addImage];
        }
    } else if (context == ImagePreviewContext) {
        if (self.previewedImageIndex > -1) {
            self.previewImage.image = [[self.images objectAtIndex:self.previewedImageIndex] objectForKey:IMAGE_KEY_FILTERED];
        } else {
            self.previewImage.image = nil;
        }
    }
}

-(void)cameraViewController:(CameraViewController *)vc didTakePicture:(UIImage *)image
{
    [cameraViewController.view removeFromSuperview];
    [cameraViewController removeFromParentViewController];
    cameraViewController = nil;
    
    [self appendImage:image];
}

-(void)cameraViewControllerDidCancel:(CameraViewController *)vc
{
    [cameraViewController.view removeFromSuperview];
    [cameraViewController removeFromParentViewController];
    cameraViewController = nil;
    
    if (self.images.count < 1) {
        [self cancel: self];
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.imagesCollection == collectionView) {
        if ([self canAddImage]) {
            return self.images.count + 1;
        }
        
        return self.images.count;
    }
    
    if (self.filtersCollection == collectionView) {
        return filters.count;
    }
    
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.imagesCollection == collectionView) {
        ImageSetPickerImageCell *cell = [self.imagesCollection dequeueReusableCellWithReuseIdentifier:CELL_IMAGE forIndexPath:indexPath];
        
        if (indexPath.row < self.images.count) {
            cell.image = [[self.images objectAtIndex:indexPath.row] objectForKey:IMAGE_KEY_RAW];
        } else {
            cell.image = nil;
        }

        return cell;
    }
    
    if (self.filtersCollection == collectionView) {
        ImageSetPickerFilterCell *cell = [self.filtersCollection dequeueReusableCellWithReuseIdentifier:CELL_FILTER forIndexPath:indexPath];
        cell.filter = [filters objectAtIndex:indexPath.row];
        
        return cell;
    }
    
    return nil;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.imagesCollection == collectionView) {
        if (indexPath.row < self.images.count) {
            // preview image
            self.previewedImageIndex = indexPath.row;
        } else {
            // add new image
            [self addImage];
        }
    } else if (self.filtersCollection == collectionView) {
        [self applyFilter:filters[indexPath.row] toImageAtIndex:self.previewedImageIndex];
    }
}

-(IBAction)cancel:(id)sender
{
    [self.delegate imageSetPickerDidCancel:self];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)validate:(id)sender
{
    [self.delegate imageSetPicker:self didReturnWithImages:_.pluck(self.images, IMAGE_KEY_FILTERED)];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)remove:(id)sender
{
    if (self.previewedImageIndex >= 0) {
        [self removeImageAtIndex:self.previewedImageIndex];
    }
}

-(void)addImage
{
    cameraViewController = [[CameraViewController alloc] initWithNibName:@"CameraViewController" bundle:nil];
    cameraViewController.delegate = self;
    [self addChildViewController:cameraViewController];
    cameraViewController.view.frame = self.view.frame;
    [self.view addSubview:cameraViewController.view];
    [cameraViewController didMoveToParentViewController:self];
}

-(BOOL)canAddImage
{
    return [self.delegate imageSetPickerMaximumImageCount:self] > self.images.count;
}

-(BOOL)canValidate
{
    return [self.delegate imageSetPickerMinimumImageCount:self] <= self.images.count;
}

-(void)appendImage:(UIImage *)image
{
    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:self.images];
    [temp addObject:@{IMAGE_KEY_RAW: image, IMAGE_KEY_FILTERED: image}];
    self.images = [[NSArray alloc] initWithArray:temp];
}

-(void)removeImageAtIndex:(NSInteger)index
{
    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:self.images];
    [temp removeObjectAtIndex:index];
    self.images = [[NSArray alloc] initWithArray:temp];
}

-(void)applyFilter:(NSString *)filter toImageAtIndex:(NSInteger)index
{
    // start from raw image
    UIImage *rawImage = [[self.images objectAtIndex:index] objectForKey:IMAGE_KEY_RAW];
    UIImage *filteredImage = rawImage; // by default do not transform

    if ([filter isEqualToString:@"sepia"]) {
        filteredImage = [rawImage toSepia];
    } else if ([filter isEqualToString:@"curve"]) {
        filteredImage = [rawImage curveFilter];
    } else if ([filter isEqualToString:@"transfer"]) {
        filteredImage = [rawImage CIPhotoEffectTransfer];
    } else if ([filter isEqualToString:@"instant"]) {
        filteredImage = [rawImage CIPhotoEffectInstant];
    } else if ([filter isEqualToString:@"process"]) {
        filteredImage = [rawImage CIPhotoEffectProcess];
    } else if ([filter isEqualToString:@"black-white"]) {
        filteredImage = [rawImage CIPhotoEffectNoir];
    } else if ([filter isEqualToString:@"vignette"]) {
        filteredImage = [rawImage vignetteWithRadius:0 andIntensity:16];
    } else if ([filter isEqualToString:@"vintage"]) {
        filteredImage = [rawImage vintageFilter];
    }

    NSMutableArray *tempImages = [[NSMutableArray alloc] initWithArray:self.images];
    [tempImages replaceObjectAtIndex:index withObject:@{IMAGE_KEY_RAW: rawImage, IMAGE_KEY_FILTERED: filteredImage}];
    self.images = [[NSArray alloc] initWithArray:tempImages];
}

@end
