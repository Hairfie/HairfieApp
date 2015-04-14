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
#import <Crashlytics/Crashlytics.h>
#import "UserAuthenticator.h"
#import <PonyDebugger/PonyDebugger.h>
#import "SearchCategory.h"


@interface AppDelegate ()

@end

@implementation AppDelegate {
    UserAuthenticator *userAuthenticator;
}

@synthesize manager = _manager, myLocation = _myLocation, credentialStore = _credentialStore, categories = _categories;

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
    //[NewRelicAgent startWithApplicationToken:NEWRELIC_APP_TOKEN];
    [Crashlytics startWithAPIKey:CRASHLYTICS_API_KEY];

    [ARAnalytics setupWithAnalytics:@{
                                      ARGoogleAnalyticsID : GOOGLE_ANALYTICS_TOKEN
                                      }];

    self.restrictRotation = YES;
    _manager = [[CLLocationManager alloc] init];
    _credentialStore = [[CredentialStore alloc] init];
    userAuthenticator = [[UserAuthenticator alloc] init];
    self.hairfieNotif = [HairfieNotifications new];
    self.hairfieUploader = [[HairfieUploader alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkStateChanged:)
                                                 name:kReachabilityChangedNotification object:nil];
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    
    NSLog(@"LOGIN STATUS : %d", [_credentialStore isLoggedIn]);
    NSLog(@"USER ID : %@", [_credentialStore userId]);

    if (self.credentialStore.isLoggedIn) {
        [[[self class] lbAdaptater] setAccessToken:self.credentialStore.authToken];

        [userAuthenticator getCurrentUser];

        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email"]
                                           allowLoginUI:NO
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             NSLog(@"FB Connected");
             _fbSession = session;
         }];
    } else {
        [self.credentialStore clearTutorialSeen];
        [self showLoginStoryboard];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveUserLanguage:)
                                                 name:@"currentUser"
                                               object:nil];
    
    [SearchCategory getCategoryWithSuccess:^(NSArray *results) {
        _categories = results;
    } failure:^(NSError *error) {
        NSLog(@"Error on categories load %@", error.description);
    }];
    
    if([ENV isEqualToString:@"dev"]) {
        PDDebugger *debugger = [PDDebugger defaultInstance];
        [debugger connectToURL:[NSURL URLWithString:@"ws://localhost:9000/device"]];
        [debugger enableNetworkTrafficDebugging];
        [debugger forwardAllNetworkTraffic];
        [debugger enableCoreDataDebugging];
        [debugger enableViewHierarchyDebugging];
    }
    
    return YES;
}

- (void)networkStateChanged:(NSNotification *)notice {
    NetworkStatus currentNetStatus = [self.reachability currentReachabilityStatus];
    if (currentNetStatus == NotReachable) {
        [self.hairfieNotif showNotificationWithMessage:NSLocalizedStringFromTable(@"No network", @"Authentication", nil)];
    } else {
        [self.hairfieNotif removeNotification];
    }
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {

    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];

    return wasHandled;
}

-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if(self.restrictRotation)
        return UIInterfaceOrientationMaskPortrait;
    else
        return UIInterfaceOrientationMaskAll;
}

- (void)showLoginStoryboard {
    [self.window.rootViewController.view removeFromSuperview];
    [self.window.rootViewController.navigationController popViewControllerAnimated:YES];

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
//    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error retrieving your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//    [errorAlert show];
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

#pragma mark - Status bar touch tracking
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    CGPoint location = [[[event allTouches] anyObject] locationInView:[self window]];
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    if (CGRectContainsPoint(statusBarFrame, location)) {
        [self statusBarTouchedAction];
    }
}

- (void)statusBarTouchedAction {
    [[NSNotificationCenter defaultCenter] postNotificationName:kStatusBarTappedNotification
                                                        object:nil];
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

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [self showAlarm:notification.alertBody];
    application.applicationIconBadgeNumber = 0;
    NSLog(@"AppDelegate didReceiveLocalNotification %@", notification.userInfo);
}

- (void)showAlarm:(NSString *)text {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alarm"
                                                        message:text delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

@end
