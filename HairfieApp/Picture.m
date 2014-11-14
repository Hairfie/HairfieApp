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

@implementation Picture {
    AppDelegate *delegate;
}

-(id)initWithDictionary:(NSDictionary *)aDictionary
{
    return [self initWithName:[aDictionary objectForKey:@"name"]
                    container:[aDictionary objectForKey:@"container"]
                          url:[NSURL URLWithString:[aDictionary objectForKey:@"url"]]];
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

-(NSString *)toApiValue
{
    
    NSLog(@"self URL %@, SELF NAME %@", self.url, self.name);
    if ([self.name length] == 0) {
        return self.url.absoluteString;
    } else {
        return self.name;
    }
}

-(NSURL *)urlWithWidth:(NSNumber *)aWidth
                height:(NSNumber *)anHeight
{
    NSURLComponents *components = [NSURLComponents componentsWithURL:self.url resolvingAgainstBaseURL:NO];
    NSMutableArray *queryItems = [[NSMutableArray alloc] initWithArray:components.queryItems];
    if (aWidth) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"width" value:[aWidth stringValue]]];
    }
    if (anHeight) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"height" value:[anHeight stringValue]]];
    }
    components.queryItems = [[NSArray alloc] initWithArray:queryItems]; // TODO: is it necessary to copy again?

    return components.URL;
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
    
    [UIImageJPEGRepresentation(_image, 1.0) writeToFile:fullPath atomically:YES];
    
    LBFileRepository *repository = (LBFileRepository*)[[AppDelegate lbAdaptater] repositoryWithClass:[LBFileRepository class]];
    LBFile __block *file =
    [repository createFileWithName:imgName localPath:imgPath container:_container];
    
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error in upload : %@", error.description);
        aFailureHandler(error);
    };
    void (^loadSuccessBlock)(NSDictionary *) = ^(NSDictionary *results){
        NSLog(@"File upload results: %@", results);
        NSDictionary *uploadedFile = [[[results objectForKey:@"result"] objectForKey:@"files"] objectForKey:@"uploadfiles"];
        self.name = [uploadedFile objectForKey:@"name"];
        self.container = [uploadedFile objectForKey:@"container"];
        self.url = [uploadedFile objectForKey:@"url"];
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
