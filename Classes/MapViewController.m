/*
     File: MapViewController.m
 Abstract: Secondary view controller used to display the map and found annotations.
  Version: 1.0
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2013 Apple Inc. All Rights Reserved.
 
 */

#import "MapViewController.h"
#import "PlaceAnnotation.h"


@interface MapViewController ()
@property (nonatomic, weak) IBOutlet MKMapView *mapView;



@property (nonatomic, strong) PlaceAnnotation *annotation;
@end

const double kPi = 3.14159265358979323846;
const double kDegreesToRadians = kPi / 180.0;
@implementation MapViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    // adjust the map to zoom/center to the annotations we want to show
    [self.mapView setRegion:self.boundingRegion];
    _distanceDurationInstructionsArray = [[NSMutableArray alloc]init];
    _finalResultsArray = [[NSMutableArray alloc]init];
    _detailInfoArray = [[NSMutableArray alloc]init];
    _distanceArray = [[NSMutableArray alloc]init];
    _durationArray = [[NSMutableArray alloc]init];
    
    if (self.mapItemList.count == 1)
    {
        MKMapItem *mapItem = [self.mapItemList objectAtIndex:0];
        
        self.title = mapItem.name;
        
        // add the single annotation to our map
        PlaceAnnotation *annotation = [[PlaceAnnotation alloc] init];
        annotation.coordinate = mapItem.placemark.location.coordinate;
        annotation.title = mapItem.name;
        annotation.url = mapItem.url;
        [self.mapView addAnnotation:annotation];
        
        // we have only one annotation, select it's callout
        [self.mapView selectAnnotation:[self.mapView.annotations objectAtIndex:0] animated:YES];
        
        // center the region around this map item's coordinate
        self.mapView.centerCoordinate = mapItem.placemark.coordinate;
    }
    else
    {
        self.title = @"All Places";
        
        // add all the found annotations to the map
        for (MKMapItem *item in self.mapItemList)
        {
            PlaceAnnotation *annotation = [[PlaceAnnotation alloc] init];
            annotation.coordinate = item.placemark.location.coordinate;
            annotation.title = item.name;
            annotation.url = item.url;
            [self.mapView addAnnotation:annotation];
        }
       MKMapItem * srcMapItem = [self.mapItemList objectAtIndex:0];
        MKMapItem * destMapItem = [self.mapItemList objectAtIndex:1];
        _srcCoordinate = srcMapItem.placemark.coordinate;
        _destCoordinate = destMapItem.placemark.coordinate;
        
        [self drawLine];
        
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.mapView removeAnnotations:self.mapView.annotations];
}

- (NSUInteger)supportedInterfaceOrientations
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return UIInterfaceOrientationMaskAll;
    else
        return UIInterfaceOrientationMaskAllButUpsideDown;
}


#pragma mark - MKMapViewDelegate


-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [UIColor purpleColor];
    polylineView.lineWidth = 5.0;
    return polylineView;
}


//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation   *)userLocation
//{

    -(void) drawLine
    {
        
        
    MKCoordinateSpan span = MKCoordinateSpanMake(0.005, 0.005);
    MKCoordinateRegion region = MKCoordinateRegionMake(_srcCoordinate, span);
    
    [_mapView setRegion:region];
    
    [_mapView setCenterCoordinate:_srcCoordinate animated:YES];
    NSString *baseUrl = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=true", _srcCoordinate.latitude,_srcCoordinate.longitude, _destCoordinate.latitude, _destCoordinate.longitude];
    
    
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
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = coordinate;
        point.title =  [leg objectForKey:@"end_address"];
        point.subtitle = @"I'm here!!!";
        
        [self.mapView addAnnotation:point];
        
        NSArray *steps = [leg objectForKey:@"steps"];
        int stepIndex = 0;
        
        CLLocationCoordinate2D stepCoordinates[1  + [steps count] + 1];
        
        stepCoordinates[stepIndex] = _srcCoordinate;
        
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
        
        
       NSString * detailsStr = [self detailedInfoStr:_detailInfoArray];
        
        float totDist = [self displayDistance:_distanceArray];
        NSLog(@"totDist : %f",totDist);
        NSString * distStr = [NSString stringWithFormat:@"%f",totDist];
        NSManagedObjectContext * context = [self managedObjectContext];
        NSManagedObject * newMapData = [NSEntityDescription insertNewObjectForEntityForName:@"MapInfo" inManagedObjectContext:context];
        [newMapData setValue:detailsStr forKey:@"detailedInfo"];
        [newMapData setValue:distStr forKey:@"distance"];
        
        if (![context save:&error]) {
            NSLog(@"error : %@",[error description]);
            
        }

        
        
        NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"MapInfo"];
        
        self.places_1 = [context executeFetchRequest:fetchRequest error:nil];
        
        
        NSManagedObject * managedObject = [self.places_1 objectAtIndex:0];
        NSLog(@"[managedObject valueForKey:%@",[managedObject valueForKey:@"detailedInfo"] );
        
        _finalResultsArray = [[NSArray alloc]initWithObjects:_detailInfoArray,_distanceArray,_durationArray, nil];
        MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:stepCoordinates count:1 + stepIndex];
        [_mapView addOverlay:polyLine];
        
        
    }];
}


- (CLLocationCoordinate2D)coordinateWithLocation:(NSDictionary*)location
{
    double latitude = [[location objectForKey:@"lat"] doubleValue];
    double longitude = [[location objectForKey:@"lng"] doubleValue];
    
    return CLLocationCoordinate2DMake(latitude, longitude);
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowDistanceDetails"]) {
        ShowDetViewController* showDetailsViewController = [segue destinationViewController];
        showDetailsViewController.detailArray = self.detailInfoArray;
        showDetailsViewController.distanceArray = self.distanceArray;
        showDetailsViewController.durationArray = self.durationArray;
    }
    if ([[segue identifier] isEqualToString:@"CalculateAutoFare"]) {
        CalculateFareViewController * calculateAutoFareViewController = [segue destinationViewController];
        calculateAutoFareViewController.distanceArr = self.distanceArray ;
    }
    
}

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

@end
