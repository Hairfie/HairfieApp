//
//  Picture.m
//  HairfieApp
//
//  Created by Antoine Hérault on 11/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "Picture.h"
#import "AppDelegate.h"
#import "SetterUtils.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Cloudinary/Cloudinary.h>

@implementation Picture {
    AppDelegate *delegate;
}

-(id)initWithDictionary:(NSDictionary *)aDictionary
{
    if([aDictionary objectForKey:@"cloudinary"]) {
        return [self initWithCloudinary:[aDictionary objectForKey:@"cloudinary"]];
    } else {
        return [self initWithName:[aDictionary objectForKey:@"name"]
                        container:[aDictionary objectForKey:@"container"]
                              url:[NSURL URLWithString:[aDictionary objectForKey:@"url"]]];
    }
}

-(id)initWithUrl:(NSURL *)anUrl
{
    return [self initWithName:nil container:nil url:anUrl];
}

-(id)initWithName:(NSString *)aName
        container:(NSString *)aContainer
              url:(NSURL *)anUrl
{
    self = [super init];
    if (self) {
        self.name = aName;
        self.container = aContainer;
        self.url = anUrl;
    }
    return self;
}

-(id)initWithImage:(UIImage *)anImage
      andContainer:(NSString *)aContainer {
    self = [super init];
    if (self) {
        self.container = aContainer;
        self.image = anImage;
    }
    return self;
}

-(id)initWithCloudinary:(NSDictionary *)aDictionary
{
    self = [super init];

    if (self) {
        self.cloudinary = [[CLCloudinary alloc] init];
        [self.cloudinary.config setValue:[aDictionary objectForKey:@"cloudName"] forKey:@"cloud_name"];
        [self.cloudinary.config setValue:[aDictionary objectForKey:@"publicId"] forKey:@"public_id"];
        self.publicId = [aDictionary objectForKey:@"publicId"];

        self.url = [NSURL URLWithString:[self.cloudinary url:[aDictionary objectForKey:@"publicId"]]];
    }
    return self;
}

-(NSString *)toApiValue
{
    if ([self.id length] == 0) {
        return self.url.absoluteString;
    } else {
        return self.id;
    }
}

-(NSURL *)urlWithWidth:(NSNumber *)aWidth
                height:(NSNumber *)anHeight
{
    if(self.cloudinary) {
        CLTransformation *transformation = [CLTransformation transformation];
        [transformation setWidthWithInt: [aWidth intValue]];
        [transformation setHeightWithInt: [anHeight intValue]];
        [transformation setCrop: @"fill"];
        
        NSString *url = [self.cloudinary url:self.publicId options:@{@"transformation": transformation}];
        
        return [NSURL URLWithString:url];
    } else {
        NSURLComponents *components = [NSURLComponents componentsWithURL:self.url resolvingAgainstBaseURL:NO];
        
        NSMutableArray *queryParts = [[NSMutableArray alloc] init];
        if ([components.query length] > 0) {
            [queryParts addObject:components.query];
        }
        if (aWidth) {
            [queryParts addObject:[NSString stringWithFormat:@"width=%@", aWidth]];
        }
        if (anHeight) {
            [queryParts addObject:[NSString stringWithFormat:@"height=%@", anHeight]];
        }
        
        if (0 == queryParts.count) {
            components.query = nil;
        } else {
            components.query = [queryParts componentsJoinedByString:@"&"];
        }
        return components.URL;
    }
}

-(void) uploadWithSuccess:(void(^)())aSuccessHandler
                  failure:(void(^)())aFailureHandler {

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *imgName = @"pictureToUpload.jpg";
    NSString *imgPath = NSTemporaryDirectory();
    
    NSString *fullPath = [imgPath stringByAppendingPathComponent:imgName];
    
    if ([fileManager fileExistsAtPath:fullPath]) {
        [fileManager removeItemAtPath:fullPath error:nil];
    }
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeImageToSavedPhotosAlbum:[self.image CGImage] orientation:(ALAssetOrientation)[self.image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){}];

    
    [UIImageJPEGRepresentation(_image, 1.0) writeToFile:fullPath atomically:YES];
    
    LBFileRepository *repository = (LBFileRepository*)[[AppDelegate lbAdaptater] repositoryWithClass:[LBFileRepository class]];
    LBFile __block *file =
    [repository createFileWithName:imgName localPath:imgPath container:_container];
    
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error in upload : %@", error.description);
        aFailureHandler(error);
    };
    void (^loadSuccessBlock)(NSDictionary *) = ^(NSDictionary *results){
        NSDictionary *uploadedFile = [results objectForKey:@"uploadfiles"];
        self.id = [uploadedFile objectForKey:@"id"];
        self.container = [uploadedFile objectForKey:@"container"];
        self.url = [NSURL URLWithString:[uploadedFile objectForKey:@"url"]];
       aSuccessHandler();
    };
    
    [file invokeMethod:@"upload"
            parameters:[file toDictionary]
               success:loadSuccessBlock
               failure:loadErrorBlock];
}

+(id)fromSetterValue:(id)aValue
{
    return [SetterUtils getInstanceOf:[self class] fromSetterValue:aValue];
}

@end
