//
//  SalonMapViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 11/3/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "SalonMapViewController.h"
#import "AppDelegate.h"
#import "MyAnnotation.h"

@interface SalonMapViewController ()

@end

@implementation SalonMapViewController
{
    AppDelegate *appDelegate;
     NSArray *menuActions;
    MyAnnotation *annotObj;
    CLLocationCoordinate2D loc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    loc = [[self.business.gps location]coordinate];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate startTrackingLocation:YES];
    self.mapView.showsPointsOfInterest = NO;
    
    
    NSLog(@"self.business %@", self.business);
     self.headerTitle.text = self.business.name;
    [self refreshMap];
    [self.mapView selectAnnotation:annotObj animated:NO];

    menuActions = @[
                    @{@"label": NSLocalizedStringFromTable(@"Report an error", @"Salon_Detail",nil), @"segue": @""}
                    ];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(MyAnnotation *)annotationForBusiness:(Business *)business
{
    annotObj =[[MyAnnotation alloc] init];
    annotObj.title = self.business.name;
    annotObj.coordinate = [[self.business.gps location] coordinate];
    
   
    
    return annotObj;
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id)annotation
{
    static NSString *myIdentifier = @"MyAnnotation";
    
    if ([annotation isKindOfClass:[MyAnnotation class]]) {
        MKAnnotationView *annotationView=[mapView dequeueReusableAnnotationViewWithIdentifier:myIdentifier];
        if (!annotationView) {
            annotationView=[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:myIdentifier];
            annotationView.image = [UIImage imageNamed:@"pin-salon.png"];
            [annotationView setFrame:CGRectMake(0, 0, 17, 24)];
            annotationView.contentMode = UIViewContentModeScaleAspectFit;
            annotationView.canShowCallout = YES;
            
        }
        return annotationView;
    }
    return nil;
}

-(void)refreshMap
{
    // clear any existing annotation
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    
    
    
    // add business pins to the map
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    [annotations addObject:[self annotationForBusiness:self.business]];
    [self.mapView addAnnotations:annotations];
    
    // tweak visible area of the map
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in self.mapView.annotations) {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        if (MKMapRectIsNull(zoomRect)) {
            zoomRect = pointRect;
        } else {
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
    }
        MKMapPoint annotationPoint = MKMapPointForCoordinate(appDelegate.currentLocation.location.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        if (MKMapRectIsNull(zoomRect)) {
            zoomRect = pointRect;
        } else {
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
    [self.mapView setVisibleMapRect:zoomRect animated:NO];
    self.mapView.camera.altitude *= 1.4;
}

-(IBAction)showMenuActionSheet:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @"Salon_Detail", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    
    
    [actionSheet addButtonWithTitle:NSLocalizedStringFromTable(@"Navigate", @"Salon_Detail", nil)];
    [actionSheet addButtonWithTitle:@"Google"];
    
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex) return; // it's the cancel button
    if (1 == buttonIndex)
        [self navigateToSalon];
    else
        [self googleMaps];
}


-(void)googleMaps {
    
    
    
    NSString *stringUrl = [NSString stringWithFormat:@"comgooglemaps://?q=%@&center=%f,%f",[self.business.address displayQueryAddress], loc.latitude, loc.longitude];
   
    NSLog(@"URL %@", stringUrl);
    // comgooglemaps://?saddr=2025+Garcia+Ave,+Mountain+View,+CA,+USA&daddr=Google,+1600+Amphitheatre+Parkway,+Mountain+View,+CA,+United+States&center=37.423725,-122.0877&directionsmode=walking&zoom=17
    if ([[UIApplication sharedApplication] canOpenURL:
         [NSURL URLWithString:@"comgooglemaps://"]]) {
        [[UIApplication sharedApplication] openURL:
         [NSURL URLWithString:stringUrl]];
    } else {
        NSLog(@"Can't use comgooglemaps://");
    }
    
}
-(void)navigateToSalon {
    
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        // Create an MKMapItem to pass to the Maps app
        
       //CLLocationDegrees
        
        
        CLLocationCoordinate2D loc2 = [[self.business.gps location]coordinate];
        
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:loc2 addressDictionary:nil];
        
            MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName:self.business.name];
        // Pass the map item to the Maps app
        [mapItem openInMapsWithLaunchOptions:nil];
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
