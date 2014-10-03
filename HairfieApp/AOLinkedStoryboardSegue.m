//
//  AOLinkedStoryboardSegue.m
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 01/10/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "AOLinkedStoryboardSegue.h"

@implementation AOLinkedStoryboardSegue

+ (UIViewController *)sceneNamed:(NSString *)identifier
{
    NSArray *cleanIdentifier = [identifier componentsSeparatedByString:@"#"];

    NSArray *info = [cleanIdentifier[0] componentsSeparatedByString:@"@"];
    
    NSString *storyboard_name = info[1];
    NSString *scene_name = info[0];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboard_name
                                                         bundle:nil];
    UIViewController *scene = nil;
    
    if (scene_name.length == 0) {
        scene = [storyboard instantiateInitialViewController];
    }
    else {
        scene = [storyboard instantiateViewControllerWithIdentifier:scene_name];
    }
    
    return scene;
}

- (id)initWithIdentifier:(NSString *)identifier
                  source:(UIViewController *)source
             destination:(UIViewController *)destination
{
    return [super initWithIdentifier:identifier
                              source:source
                         destination:[AOLinkedStoryboardSegue sceneNamed:identifier]];
}

- (void)perform
{
    UIViewController *source = (UIViewController *)self.sourceViewController;
    NSLog(@"Destination class : %@", [self.destinationViewController class]);
    if ([self.destinationViewController isKindOfClass:[UINavigationController class]]) {
        [source.navigationController presentViewController:self.destinationViewController animated:NO completion:nil];
    } else {
        [source.navigationController pushViewController:self.destinationViewController
                                               animated:YES];
    }
}

@end