//
//  AppDelegate.m
//  HairfieApp
//
//  Created by Ghislain on 25/07/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "AppDelegate.h"
#import "MenuViewController.h"
#import "Constants.h"
#import "CredentialStore.h"
#import "HomeViewController.h"
#import "ECSlidingViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Crashlytics/Crashlytics.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize manager = _manager, myLocation = _myLocation, credentialStore = _credentialStore;

static LBRESTAdapter * _lbAdaptater = nil;

+ (LBRESTAdapter *) lbAdaptater
{
    if ( !_lbAdaptater) {
        _lbAdaptater = [LBRESTAdapter adapterWithURL:[NSURL URLWithString:API_URL]];
    }
    return _lbAdaptater;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [NewRelicAgent startWithApplicationToken:NEWRELIC_APP_TOKEN];
    //[Crashlytics startWithAPIKey:CRASHLYTICS_API_KEY];
    
    [ARAnalytics setupWithAnalytics:@{
                                      ARGoogleAnalyticsID : GOOGLE_ANALYTICS_TOKEN
                                      }];
    
    _manager = [[CLLocationManager alloc] init];
    _credentialStore = [[CredentialStore alloc] init];

    NSLog(@"LOGIN STATUS : %d", [_credentialStore isLoggedIn]);
    NSLog(@"USER ID : %@", [_credentialStore userId]);

    if (self.credentialStore.isLoggedIn) {
        [[[self class] lbAdaptater] setAccessToken:self.credentialStore.authToken];
        [User getById:self.credentialStore.userId
              success:^(User *user) {
                  self.currentUser = user;
                  NSLog(@"USER : %@", self.currentUser.picture.url);
                  [[NSNotificationCenter defaultCenter] postNotificationName:@"currentUser" object:nil];
              }
              failure:^(NSError *error) {
                  NSLog(@"Error retrieving logged in user: %@", error.localizedDescription);
                  self.currentUser = nil;
                  [self.credentialStore clearSavedCredentials];
              }];
    } else {
        [self.credentialStore clearTutorialSeen];
        [self showLoginStoryboard];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveUserLanguage:)
                                                 name:@"currentUser"
                                               object:nil];
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {

    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    return wasHandled;
}

- (void)showLoginStoryboard {
    [self.window.rootViewController.view removeFromSuperview];
    [self.window.rootViewController.navigationController popViewControllerAnimated:NO];

    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Tuto" bundle:nil];
    UINavigationController *theInitialViewController = [storyBoard instantiateInitialViewController];
    NSLog(@"root : %@", [self.window.rootViewController class]);

    [self.window setRootViewController:theInitialViewController];
}

-(void)saveUserLanguage:(NSNotification *)notification
{
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if (![self.currentUser.language isEqual:language]) {
        self.currentUser.language = language;
        [self.currentUser saveWithSuccess:^() { NSLog(@"Current user language saved"); }
                                  failure:^(NSError *error) { NSLog(@"Failed to save language: %@", error.localizedDescription); }];
    }
}


-(void)startTrackingLocation:(BOOL)forceLocation
{
    if (forceLocation == YES)
    {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
            [_manager requestWhenInUseAuthorization];
        }
        _manager.delegate = self;
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
        [_manager startUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error retrieving your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
    NSLog(@"Error: %@",error.description);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{

   _myLocation = [locations lastObject];
    if (nil == _myLocation) {
        self.currentLocation = nil;
    } else {
        self.currentLocation = [[GeoPoint alloc] initWithLocation:self.myLocation];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newLocationNotif"
                                                        object:self
                                                      userInfo:[NSDictionary dictionaryWithObject:_myLocation
                                                                                           forKey:@"newLocationResult"]];

    [manager stopUpdatingLocation];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
