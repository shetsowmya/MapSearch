//  TrackAndDisplayRouteViewController.m
//  MapSearch
//
//  Created by Nidhi on 22/08/15.
//
//

#import "TrackAndDisplayRouteViewController.h"

@interface TrackAndDisplayRouteViewController ()
@property BOOL flag;
//@property CLLocationCoordinate2D stepCoordinate1;
//@property CLLocationCoordinate2D stepCoordinate2;
@property (strong) NSString * srcAddress,* destAddress;
//@property (nonatomic, strong) CrumbPath *crumbs;
//@property (nonatomic, strong) CrumbPathRenderer *crumbPathRenderer;

@end

@implementation AddressAnnotation1
- (NSString *)pinNumber{
    return _pinNumber;
}

- (void) setpincolor:(NSNumber*) String1{
     _pinNumber = String1;
}
@end
@implementation TrackAndDisplayRouteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BOOL isSrc = false;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Home_Template.png"]];
    
    [self.routeMap addAnnotation:self.srcAnnotation];
    [self.routeMap addAnnotation:self.destAnnotation];
    self.flag = true;
    self.routeMap.delegate = self;
    CLGeocoder * fgeo = [[CLGeocoder alloc] init];

    CLLocation *dLoc = [[CLLocation alloc] initWithCoordinate:self.destLocation altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];
    
    
    CLLocation *sLoc = [[CLLocation alloc] initWithCoordinate:self.srcLocation altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];

    self.srcAddress = [self reverseGeocode:sLoc flag:YES];
    self.destAddress = [self reverseGeocode:dLoc flag:NO];

    
   /// self.stepCoordinates =  malloc(2 * sizeof(CLLocationCoordinate2D));
   /// self.stepCoordinates[0] = kCLLocationCoordinate2DInvalid;
   /// [self.routeMap setShowsUserLocation: YES];
   /// [self.routeMap setUserTrackingMode: MKUserTrackingModeFollow animated: NO];
    
   /// self.locationManager = [[CLLocationManager alloc] init];
   
   /// if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
   ///     [self.locationManager requestWhenInUseAuthorization];
   /// }
   /// [[self locationManager] setDelegate:self];
   /// [[self locationManager] setDesiredAccuracy:kCLLocationAccuracyBest];
   /// [[self locationManager] startMonitoringSignificantLocationChanges];
   /// [[self locationManager] startUpdatingLocation];

    [self zoomToFitMapAnnotations:self.routeMap location:self.srcLocation];
    [self zoomToFitMapAnnotations:self.routeMap location:self.destLocation];
    
    [self.routeMap removeOverlays:self.routeMap.overlays];
    // Do any additional setup after loading the view.
    
    
//    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(foundTap:)];
//    
//    tapRecognizer.numberOfTapsRequired = 1;
//    
//    tapRecognizer.numberOfTouchesRequired = 1;
//    
//    [self.routeMap addGestureRecognizer:tapRecognizer];
    
  
    /*
    // start with our position and derive a nice unit for drawing
    CLLocationCoordinate2D loc = self.srcLocation;
    CGFloat lat = loc.latitude;
    CLLocationDistance metersPerPoint = MKMetersPerMapPointAtLatitude(lat);
    MKMapPoint c = MKMapPointForCoordinate(loc);
    CGFloat unit = 75.0/metersPerPoint;
    // size and position the overlay bounds on the earth
    CGSize sz = CGSizeMake(4*unit, 4*unit);
    MKMapRect mr =
    MKMapRectMake(c.x + 2*unit, c.y - 4.5*unit, sz.width, sz.height);
    // describe the arrow as a CGPath
    CGMutablePathRef p = CGPathCreateMutable();
    CGPoint start = CGPointMake(0, unit*1.5);
    CGPoint p1 = CGPointMake(start.x+2*unit, start.y);
    CGPoint p2 = CGPointMake(p1.x, p1.y-unit);
    CGPoint p3 = CGPointMake(p2.x+unit*2, p2.y+unit*1.5);
    CGPoint p4 = CGPointMake(p2.x, p2.y+unit*3);
    CGPoint p5 = CGPointMake(p4.x, p4.y-unit);
    CGPoint p6 = CGPointMake(p5.x-2*unit, p5.y);
    CGPoint points[] = {
        start, p1, p2, p3, p4, p5, p6
    };
    // rotate the arrow around its center
    CGAffineTransform t1 = CGAffineTransformMakeTranslation(unit*2, unit*2);
    CGAffineTransform t2 = CGAffineTransformRotate(t1, -M_PI/3.5);
    CGAffineTransform t3 = CGAffineTransformTranslate(t2, -unit*2, -unit*2);
    CGPathAddLines(p, &t3, points, 7);
    CGPathCloseSubpath(p);
    // create the overlay and give it the path
    MyOverlay1* over = [[MyOverlay1 alloc] initWithRect:mr];
    over.path = [UIBezierPath bezierPathWithCGPath:p];
    CGPathRelease(p);
    // add the overlay to the map
    [self.routeMap addOverlay:over];
*/
    
    
}



-(NSString *)reverseGeocode:(CLLocation *)loc flag:(BOOL)isSrc
{
    CLGeocoder * fgeo = [[CLGeocoder alloc]init];
    __block NSString * address = [[NSString alloc]init];
    [fgeo reverseGeocodeLocation:loc
               completionHandler:^(NSArray *placemarks, NSError *error){
                   if(!error){
                       CLPlacemark *placemark = [placemarks objectAtIndex:0];
                       
                       if (isSrc == YES) {
                           self.srcAddress = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                       }
                       else
                       {
                           self.destAddress = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];

                       }
                   }
               }
     ];
    return address;

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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
    
    [self drawLine];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //[mapView setCenterCoordinate:userLocation.coordinate animated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetails"]) {
        ShowTravelDetailsTableViewController * trackVC = [segue destinationViewController];
        trackVC.routeStepsArr = self.steps;
        trackVC.srcAddress = self.srcAddress;
        trackVC.destAddress = self.destAddress;
        NSLog(@"sowmya: src: %@", trackVC.srcAddress);
        NSLog(@"dest: %@",trackVC.destAddress);
        
    }
    if ([[segue identifier] isEqualToString:@"startRouteTracking"]){
        PathTrackingViewController * pathtrackVC = [segue destinationViewController];
        pathtrackVC.srcAnnotation = self.srcAnnotation;
        pathtrackVC.destAnnotation = self.destAnnotation;
        pathtrackVC.srcLocation = self.srcLocation;
        pathtrackVC.destLocation = self.destLocation;
    }
}

- (MKCoordinateRegion)coordinateRegionWithCenter:(CLLocationCoordinate2D)centerCoordinate approximateRadiusInMeters:(CLLocationDistance)radiusInMeters
{
    // Multiplying by MKMapPointsPerMeterAtLatitude at the center is only approximate, since latitude isn't fixed
    //
    double radiusInMapPoints = radiusInMeters*MKMapPointsPerMeterAtLatitude(centerCoordinate.latitude);
    MKMapSize radiusSquared = {radiusInMapPoints,radiusInMapPoints};
    
    MKMapPoint regionOrigin = MKMapPointForCoordinate(centerCoordinate);
    MKMapRect regionRect = (MKMapRect){regionOrigin, radiusSquared}; //origin is the top-left corner
    
    regionRect = MKMapRectOffset(regionRect, -radiusInMapPoints/2, -radiusInMapPoints/2);
    
    // clamp the rect to be within the world
    regionRect = MKMapRectIntersection(regionRect, MKMapRectWorld);
    
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(regionRect);
    return region;
}

/*

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
        [self zoomToFitMapAnnotations:self.routeMap location:self.srcLocation];
        [self zoomToFitMapAnnotations:self.routeMap location:self.destLocation];
        self.flag = false;
    }
    [self.latitude setText:latitude];
    [self.longitude setText:longitude];
    
    
  //  NSLog(@"coordinates before: %f,%f,%f,%f",self.stepCoordinates[0].latitude,self.stepCoordinates[0].longitude,self.stepCoordinates[1].latitude,self.stepCoordinates[1].longitude);
    if (CLLocationCoordinate2DIsValid(self.stepCoordinates[0])) {
        MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:self.stepCoordinates count:2];
       // ////[self.routeMap addOverlay:polyLine];
    }
    self.stepCoordinates[0] = coordinate;
    
    [self drawLine];
}

*/
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
                
                self.srcAddress = [self reverseGeocode:sLoc flag:YES];
                self.destAddress = [self reverseGeocode:dLoc flag:NO];

                
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

/*
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"error: %@", error.localizedDescription);
}
*/
 
#pragma mark - MapKit

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer *renderer =[[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 3.0;
    return renderer;
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView1 viewForAnnotation:(AddressAnnotation1 *) annotation
{
//    UIImage *anImage = nil;
//    
//    MKAnnotationView *annView=(MKAnnotationView*)[mapView1 dequeueReusableAnnotationViewWithIdentifier:@"annotation"];
//    if(annView==nil){
//        annView=[[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation"] autorelease];
//    }
//    if([annotation.mPinColor isEqualToString:@"green"])
//    {
//        anImage=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Google map pin 02.png" ofType:nil]];
//    }
//    else if([annotation.mPinColor isEqualToString:@"red"])
//    {
//        anImage=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Google map pin 01.png" ofType:nil]];
//    }
//    else if([annotation.mPinColor isEqualToString:@"blue"])
//    {
//        anImage=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Google map pin 02.png" ofType:nil]];
//    }
//    annView.image = anImage;
//    return annView;
}
/*
//adding arrow
- (MKOverlayView*)mapView:(MKMapView*)mapView
           viewForOverlay:(id <MKOverlay>)overlay {
    MKOverlayView* v = nil;
    if ([overlay isKindOfClass: [MyOverlay1 class]]) {
        v = [[MKOverlayPathView alloc] initWithOverlay:overlay];
        MKOverlayPathView* vv = (MKOverlayPathView*)v;
        vv.path = ((MyOverlay1*)overlay).path.CGPath;
        vv.strokeColor = [UIColor blackColor];
        vv.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
        vv.lineWidth = 2;
    }
    return v;
}

//foundTap action method
//-(IBAction)foundTap:(UITapGestureRecognizer *)recognizer
//{
//    CGPoint point = [recognizer locationInView:self.routeMap];
//    
//    CLLocationCoordinate2D tapPoint = [self.routeMap convertPoint:point toCoordinateFromView:self.view];
//    
//    MKPointAnnotation *point1 = [[MKPointAnnotation alloc] init];
//    
//    point1.coordinate = tapPoint;
//    
//   // [self.routeMap addAnnotation:point1];
//    NSLog(@"tapPoint : %f,%f",tapPoint.latitude,tapPoint.longitude);
//}

 */
@end
