//
//  TrackRouteViewController.m
//  MapSearch
//
//  Created by Nidhi on 14/08/15.
//
//

#import "TrackRouteViewController.h"
#import "PlaceAnnotation.h"

@interface TrackRouteViewController ()
@property CLLocationCoordinate2D srcLoc,destLoc;
@property (readwrite,strong) NSMutableArray * instructionsArr;
@end

@implementation TrackRouteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Home_Template.png"]];
    
    self.srcSearchBar.delegate = self;
    self.destSearchBar.delegate = self;
    self.routeMap.delegate = self;
    [self.view setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];

    
    _detailInfoArray = [[NSMutableArray alloc]init];
    _distanceArray = [[NSMutableArray alloc]init];
    _durationArray = [[NSMutableArray alloc]init];
    
    
    UISwipeGestureRecognizer *ges =[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    [self.view addGestureRecognizer:ges];
    

    
    // Do any additional setup after loading the view.
}

-(void)swipe:(UISwipeGestureRecognizer *)swipeGes{
    if(swipeGes.direction == UISwipeGestureRecognizerDirectionUp){
        [UIView animateWithDuration:.5 animations:^{
            //set frame of bottom view to top of screen (show 100%)
            self.view.frame =CGRectMake(0, 0, 320, self.view.frame.size.height);
        }];
    }
    else if (swipeGes.direction == UISwipeGestureRecognizerDirectionDown){
        [UIView animateWithDuration:.5 animations:^{
            //set frame of bottom view to bottom of screen (show 60%)
            self.view.frame =CGRectMake(0, 300, 320, self.view.frame.size.height);
        }];
    }
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

-(NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext * context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if( [delegate performSelector:@selector(managedObjectContext)])
    {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.srcSearchBar resignFirstResponder];
    [self.destSearchBar resignFirstResponder];
    CLGeocoder * geocoder = [[CLGeocoder alloc]init];
    [geocoder geocodeAddressString:searchBar.text completionHandler:^(NSArray * placemarks,NSError * error){
        CLPlacemark * placemark  = [ placemarks objectAtIndex:0];
        MKCoordinateRegion region;
        CLLocationCoordinate2D newLocation = [placemark.location coordinate];
        region.center = [(CLCircularRegion *)placemark.region center];
        
        NSMutableArray * annotationArr = [[NSMutableArray alloc] init];
        if (searchBar.tag == 1) {
            [self.routeMap removeAnnotation:self.srcAnnotation];
            self.srcAnnotation = [[MKPointAnnotation alloc]init];
            [self.srcAnnotation setCoordinate:newLocation];
            [self.srcAnnotation setTitle:self.srcSearchBar.text];
            [self.routeMap addAnnotation:self.srcAnnotation];
            [annotationArr addObject:self.srcAnnotation];
            self.srcLoc = newLocation;
        }
        else if(searchBar.tag == 2){
            [self.routeMap removeAnnotation:self.destAnnotation];
            self.destAnnotation = [[MKPointAnnotation alloc]init];
            [self.destAnnotation setCoordinate:newLocation];
            [self.destAnnotation setTitle:self.destSearchBar.text];
            [self.routeMap addAnnotation:self.destAnnotation];
            [annotationArr addObject:self.destAnnotation];
            self.destLoc = newLocation;
        }
        
        //        MKMapRect mr = [self.mapView visibleMapRect];
        //        MKMapPoint pt = MKMapPointForCoordinate([annotation coordinate]);
        //        mr.origin.x = pt.x - mr.size.width * 0.5;
        //        mr.origin.y = pt.y - mr.size.width * 0.25;
        //        [self.mapView setVisibleMapRect:mr animated:YES];
        self.routeMap.centerCoordinate = newLocation;
        
        //MKCoordinateSpan span = MKCoordinateSpanMake(0.005, 0.005);
       // region = MKCoordinateRegionMake(newLocation, span);
       // [self.routeMap setRegion:region];
        [self zoomToFitMapAnnotations:self.routeMap location:newLocation];

        
    }];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
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

- (void)drawLine
{
    self.instructionsArr = [[NSMutableArray alloc] init];
    MKPlacemark *source = [[MKPlacemark   alloc]initWithCoordinate:CLLocationCoordinate2DMake(self.srcLoc.latitude, self.srcLoc.longitude)   addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    MKMapItem *srcMapItem = [[MKMapItem alloc]initWithPlacemark:source];
    [srcMapItem setName:@""];
    
    MKPlacemark *destination = [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake(self.destLoc.latitude, self.destLoc.longitude) addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    
    MKMapItem *distMapItem = [[MKMapItem alloc]initWithPlacemark:destination];
    [distMapItem setName:@""];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];
    [request setSource:srcMapItem];
    [request setDestination:distMapItem];
    [request setTransportType:MKDirectionsTransportTypeWalking];
    
    MKDirections *direction = [[MKDirections alloc]initWithRequest:request];
    
    [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        
        NSLog(@"response = %@",response);
        NSArray *arrRoutes = [response routes];
        [arrRoutes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            MKRoute *rout = obj;
            
            MKPolyline *line = [rout polyline];
            [self.routeMap addOverlay:line];
            NSLog(@"Rout Name : %@",rout.name);
            NSLog(@"Total Distance (in Meters) :%f",rout.distance);
            
            NSArray *steps = [rout steps];
            
            NSLog(@"Total Steps : %d",[steps count]);
            
            [steps enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSLog(@"Rout Instruction : %@",[obj instructions]);
                [self.instructionsArr addObject:[obj instructions]];
                NSLog(@"Rout Distance : %f",[obj distance]);
            }];
            NSLog(@"instructionsArr  ; %@",self.instructionsArr);

        }];
    }];
}

-(void) drawLine1
{
    
//    
//    MKCoordinateSpan span = MKCoordinateSpanMake(0.005, 0.005);
//    MKCoordinateRegion region = MKCoordinateRegionMake(self.srcLoc, span);
//    
//    [self.routeMap setRegion:region];
    
    //[self.routeMap setCenterCoordinate:self.srcLoc animated:YES];
    NSString *baseUrl = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=true", self.srcLoc.latitude,self.srcLoc.longitude, self.destLoc.latitude, self.destLoc.longitude];
    
    
    //http://maps.googleapis.com/maps/api/directions/json?origin=23.030000,72.580000&destination=23.400000,72.750000&sensor=true
    
    NSURL *url = [NSURL URLWithString:[baseUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //  NSLog(@"%@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSError *error = nil;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        NSArray *routes = [result objectForKey:@"routes"];
        // NSLog(@"%@",routes);
        
        NSDictionary *firstRoute = [routes objectAtIndex:0];
        
        NSDictionary *leg =  [[firstRoute objectForKey:@"legs"] objectAtIndex:0];
        
        NSDictionary *end_location = [leg objectForKey:@"end_location"];
        
        // NSLog(@"dDDDDDD>>>>>>%@",leg);
        double latitude = [[end_location objectForKey:@"lat"] doubleValue];
        double longitude = [[end_location objectForKey:@"lng"] doubleValue];
        
        
//        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
//        point.coordinate = coordinate;
//        point.title =  [leg objectForKey:@"end_address"];
//        point.subtitle = @"I'm here!!!";
//        
//        [self.routeMap addAnnotation:point];
        
        NSArray *steps = [leg objectForKey:@"steps"];
        NSArray * distance = [leg objectForKey:@"distance"];
        int stepIndex = 0;
        
        CLLocationCoordinate2D stepCoordinates[1  + [steps count] + 1];
        
        stepCoordinates[stepIndex] = self.srcLoc;
        
        for (NSDictionary *step in steps) {
            
            NSDictionary * html_inst = [step objectForKey:@"html_instructions"];
            NSDictionary * distance = [step objectForKey:@"distance"];
            NSDictionary * duration = [step objectForKey:@"duration"];
            
            
            [_distanceDurationInstructionsArray addObject:html_inst];
            [_distanceDurationInstructionsArray addObject:distance];
            [_distanceDurationInstructionsArray addObject:duration];
            
            
            
            //calling core data
            
            ;
            
            
            NSDictionary *start_location = [step objectForKey:@"start_location"];
            stepCoordinates[++stepIndex] = [self coordinateWithLocation:start_location];

            if ([steps count] == stepIndex){
                NSDictionary *end_location = [step objectForKey:@"end_location"];
                stepCoordinates[++stepIndex] = [self coordinateWithLocation:end_location];
            }
        }
        
        for (int i = 0; i<_distanceDurationInstructionsArray.count; i=i+3) {
            [_detailInfoArray addObject:[_distanceDurationInstructionsArray objectAtIndex:i]];
            [_distanceArray addObject:[_distanceDurationInstructionsArray objectAtIndex:i+1]];
            [_durationArray addObject:[_distanceDurationInstructionsArray objectAtIndex:i+2]];
        }
        
        
        NSLog(@"distance : %@",[distance valueForKey:@"value"]);
        
        _finalResultsArray = [[NSArray alloc]initWithObjects:_detailInfoArray,_distanceArray,_durationArray, nil];
        MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:stepCoordinates count:1 + stepIndex];
        polyLine.title = [NSString stringWithFormat:@"%@",[distance valueForKey:@"value"]];
        [self.routeMap addOverlay:polyLine];
        
        
    }];
}

- (CLLocationCoordinate2D)coordinateWithLocation:(NSDictionary*)location
{
    double latitude = [[location objectForKey:@"lat"] doubleValue];
    double longitude = [[location objectForKey:@"lng"] doubleValue];
    
    return CLLocationCoordinate2DMake(latitude, longitude);
}
-(NSString *)detailedInfoStr:(NSArray *)infoDict
{
    NSString * finalStr = [[NSString alloc]init];
    //detailsTextView.text = [detailsTextView.text stringByAppendingString:@"sowmya"];
    for (NSUInteger i=0; i<[infoDict count]; i++) {
        NSString * str = [infoDict objectAtIndex:i];
        
        finalStr = [finalStr stringByAppendingString:str];
        finalStr = [finalStr stringByAppendingString:@" \n"];
        // detailsTextView.text = [detailsTextView.text stringByAppendingString:@"\n"];
    }
    NSString * detailsStr = [self convertHTML:finalStr];
    
    return detailsStr;
}

-(NSString *)convertHTML:(NSString *)html {
    
    NSScanner *myScanner;
    NSString *text = nil;
    myScanner = [NSScanner scannerWithString:html];
    
    while ([myScanner isAtEnd] == NO) {
        
        [myScanner scanUpToString:@"<" intoString:NULL] ;
        
        [myScanner scanUpToString:@">" intoString:&text] ;
        
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@" "];
    }
    //
    html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return html;
}

-(float) displayDistance:(NSArray *) distArr
{
    float _totaldistance = 0;
    for (NSUInteger i=0; i< [distArr count]; i++) {
        NSDictionary * dict = [distArr objectAtIndex:i];
        int value = [[dict objectForKey:@"value"] intValue];
        _totaldistance = _totaldistance + value;
    }
    _totaldistance = _totaldistance/1000;
    return _totaldistance;
}

//
//-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
//{
//    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
//    polylineView.strokeColor = [UIColor purpleColor];
//    polylineView.lineWidth = 5.0;
//    return polylineView;
//}



- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer *renderer =[[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 3.0;
    return renderer;
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"trackRoute"]) {
        TrackAndDisplayRouteViewController * trackVC = [segue destinationViewController];
        trackVC.srcAnnotation = self.srcAnnotation;
        trackVC.destAnnotation = self.destAnnotation;
        trackVC.srcLocation = self.srcLoc;
        trackVC.destLocation = self.destLoc;
        trackVC.instructionsArr = self.instructionsArr;

    }
}

@end
