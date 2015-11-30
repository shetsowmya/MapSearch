//
//  PathTrackingViewController.m
//  MapSearch
//
//  Created by Nidhi on 14/09/15.
//
//

#import "PathTrackingViewController.h"

@interface PathTrackingViewController ()
@property BOOL flag;

@end

@implementation PathTrackingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.flag = true;

    [self.routeMap addAnnotation:self.srcAnnotation];
    [self.routeMap addAnnotation:self.destAnnotation];
    self.stepCoordinates =  malloc(2 * sizeof(CLLocationCoordinate2D));
    self.stepCoordinates[0] = kCLLocationCoordinate2DInvalid;
    [self.routeMap setShowsUserLocation: YES];
    [self.routeMap setUserTrackingMode: MKUserTrackingModeFollow animated: NO];
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [[self locationManager] setDelegate:self];
    [[self locationManager] setDesiredAccuracy:kCLLocationAccuracyBest];
    [[self locationManager] startMonitoringSignificantLocationChanges];
    [[self locationManager] startUpdatingLocation];
    
    [self.routeMap removeOverlays:self.routeMap.overlays];
    self.routeMap.delegate = self;

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)zoomToFitMapAnnotations:(MKMapView *)mapView location:(CLLocationCoordinate2D)newLocation {
    if ([mapView.annotations count] == 0) return;
    if ([mapView.annotations count] == 1) {
        MKCoordinateSpan span = MKCoordinateSpanMake(0.005, 0.005);
        MKCoordinateRegion region = MKCoordinateRegionMake(newLocation, span);
        [self.routeMap setRegion:region];
        return;
    }
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(id<MKAnnotation> annotation in mapView.annotations) {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    
    // Add a little extra space on the sides
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.5;
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.5;
    
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
}


-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = locations.lastObject;
    //NSLog(@"location: %f",location.coordinate.latitude);
    
    
    CLLocationCoordinate2D coordinate = [location coordinate];
    self.stepCoordinates[1] = coordinate;
    NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    
    //[self.routeMap setCenterCoordinate:coordinate];
    if (self.flag == true) {
        [self zoomToFitMapAnnotations:self.routeMap location:coordinate];
        //[self zoomToFitMapAnnotations:self.routeMap location:self.srcLocation];
        //[self zoomToFitMapAnnotations:self.routeMap location:self.destLocation];
        self.flag = false;
    }
    
    
    //  NSLog(@"coordinates before: %f,%f,%f,%f",self.stepCoordinates[0].latitude,self.stepCoordinates[0].longitude,self.stepCoordinates[1].latitude,self.stepCoordinates[1].longitude);
    if (CLLocationCoordinate2DIsValid(self.stepCoordinates[0])) {
        MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:self.stepCoordinates count:2];
    
        [self.routeMap addOverlay:polyLine];
    }
    self.stepCoordinates[0] = coordinate;
    
    [self drawLine];
}

- (void)drawLine
{
    self.instructionsArr = [[NSMutableArray alloc] init];
    
    
    
    MKPlacemark *source = [[MKPlacemark   alloc]initWithCoordinate:CLLocationCoordinate2DMake(self.srcLocation.latitude, self.srcLocation.longitude)   addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    MKMapItem *srcMapItem = [[MKMapItem alloc]initWithPlacemark:source];
    [srcMapItem setName:@""];
    
    MKPlacemark *destination = [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake(self.destLocation.latitude, self.destLocation.longitude) addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    
    MKMapItem *distMapItem = [[MKMapItem alloc]initWithPlacemark:destination];
    [distMapItem setName:@""];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];
    [request setSource:srcMapItem];
    [request setDestination:distMapItem];
    [request setTransportType:MKDirectionsTransportTypeWalking];
    
    MKDirections *direction = [[MKDirections alloc]initWithRequest:request];
    
    [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        
        // NSLog(@"response = %@",response);
        NSArray *arrRoutes = [response routes];
        [arrRoutes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            MKRoute *rout = obj;
            
            MKPolyline *line = [rout polyline];
    
            [self.routeMap addOverlay:line];
            NSLog(@"Rout Name : %@",rout.name);
            NSLog(@"rout coordinate: %@",rout.polyline);
            NSLog(@"Total Distance (in Meters) :%f",rout.distance);
            
            self.steps = [rout steps];
            
            
            //   NSLog(@"Total Steps : %d",[steps count]);
            
            [self.steps enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSLog(@"Rout Instruction : %@",[obj instructions]);
                [self.instructionsArr addObject:[obj instructions]];
                
                MKRoute *route = obj;
                
                CLLocation *dLoc = [[CLLocation alloc] initWithCoordinate:self.destLocation altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];
                
                
                CLLocation *sLoc = [[CLLocation alloc] initWithCoordinate:self.srcLocation altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];
                
                
                
                MKPolyline *line1 = [route polyline];
                
                // MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:line1];
                //renderer.strokeColor = [UIColor redColor];
                //[renderer setLineCap:kCGLineCapRound];
                //   [self.routeMap addOverlay:line1];
                
            }];
            
            //  NSLog(@"instructionsArr  ; %@",self.instructionsArr);
            
        }];
    }];
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"error: %@", error.localizedDescription);
}

#pragma mark - MapKit

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer *renderer =[[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 3.0;
    return renderer;
}



@end
