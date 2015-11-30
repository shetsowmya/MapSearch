//
//  CheckFareViewController.m
//  MapSearch
//
//  Created by Nidhi on 02/08/15.
//
//

#import "CheckFareViewController.h"




@interface CheckFareViewController ()
@property CLLocationCoordinate2D srcLoc,destLoc;
@property float distance;
@property UIDatePicker *datepicker;
@property NSDate * travelDate;
@property UIPopoverController *popOverForDatePicker;
@property (strong, nonatomic) IBOutlet UITextField *dateTextFeild;
@property (strong, nonatomic) IBOutlet UIButton *selectDateBtn;
- (IBAction)selectDate:(id)sender;
@end


@implementation CheckFareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Home_Template.png"]];
   
    self.getEstimateBtn.layer.borderWidth = 0.5f;
    self.getEstimateBtn.layer.borderColor = [[UIColor blackColor]CGColor];
    self.getEstimateBtn.layer.cornerRadius = 10;
    
    self.selectDateBtn.layer.cornerRadius = 10;
    self.selectDateBtn.layer.borderWidth = 1;
    self.selectDateBtn.layer.borderColor = [UIColor blueColor].CGColor;
    self.selectDateBtn.layer.backgroundColor = [UIColor lightTextColor].CGColor;

    self.fareChart.layer.cornerRadius = 10;
    self.fareChart.layer.borderWidth = 1;
    self.fareChart.layer.borderColor = [UIColor blueColor].CGColor;
    self.fareChart.layer.backgroundColor = [UIColor lightTextColor].CGColor;
    
    self.resetBtn.layer.cornerRadius = 10;
    self.resetBtn.layer.borderWidth = 1;
    self.resetBtn.layer.borderColor = [UIColor blueColor].CGColor;
    self.resetBtn.layer.backgroundColor = [UIColor lightTextColor].CGColor;
    
    [self.view setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    self.srcSearchBar.delegate = self;
    self.destSearchBar.delegate = self;
    self.mapView.delegate = self;
    // Do any additional setup after loading the view.
    
    //self.travelDate.transform = CGAffineTransformMakeScale(0.75, 0.5);
    
    [self.fareText setHidden:YES];
     [self.fareChart setHidden:YES];
    
    
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

        if (searchBar.tag == 1) {
        [self.mapView removeAnnotation:self.srcAnnotation];
        self.srcAnnotation = [[MKPointAnnotation alloc]init];
        [self.srcAnnotation setCoordinate:newLocation];
        [self.srcAnnotation setTitle:self.srcSearchBar.text];
        [self.mapView addAnnotation:self.srcAnnotation];
            self.srcLoc = newLocation;
        }
        else if(searchBar.tag == 2){
            [self.mapView removeAnnotation:self.destAnnotation];
            self.destAnnotation = [[MKPointAnnotation alloc]init];
            [self.destAnnotation setCoordinate:newLocation];
            [self.destAnnotation setTitle:self.destSearchBar.text];
            [self.mapView addAnnotation:self.destAnnotation];
            self.destLoc = newLocation;
        }
        
//        MKMapRect mr = [self.mapView visibleMapRect];
//        MKMapPoint pt = MKMapPointForCoordinate([annotation coordinate]);
//        mr.origin.x = pt.x - mr.size.width * 0.5;
//        mr.origin.y = pt.y - mr.size.width * 0.25;
//        [self.mapView setVisibleMapRect:mr animated:YES];
        self.mapView.centerCoordinate = newLocation;
        
//        MKCoordinateSpan span = MKCoordinateSpanMake(0.005, 0.005);
//        region = MKCoordinateRegionMake(newLocation, span);
//        [self.mapView setRegion:region];
        [self zoomToFitMapAnnotations:self.mapView location:newLocation];

        
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
        [self.mapView setRegion:region];
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
    NSMutableArray * instructionsArr = [[NSMutableArray alloc] init];
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
            [self.mapView addOverlay:line];
            NSLog(@"Rout Name : %@",rout.name);
            NSLog(@"Total Distance (in Meters) :%f",rout.distance);
            
            NSArray *steps = [rout steps];
            
            NSLog(@"Total Steps : %d",[steps count]);
            
            [steps enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSLog(@"Rout Instruction : %@",[obj instructions]);
                [instructionsArr addObject:[obj instructions]];
            }];
            NSLog(@"instructionsArr  ; %@",instructionsArr);
            
        }];
    }];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer *renderer =[[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 2.0;
    renderer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:10],[NSNumber numberWithInt:7], nil];
    return renderer;
}


- (IBAction)fareChart:(id)sender {
    if ([self.srcSearchBar.text isEqualToString:@"" ]|| [self.destSearchBar.text isEqualToString:@""]) {
        UIAlertView *ErrorAlert = [[UIAlertView alloc] initWithTitle:@"Error!!"
                                                             message:@"Please enter src and destination text feilds." delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil, nil];
        [ErrorAlert show];
    }

    else{
        [self calculateDistance];
        
        
        [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"serviceProvider"] animated:NO completion:NULL];
        
    }
}

- (IBAction)waitingChargeSwitch:(id)sender {
    UISwitch *waitingSwitch = (UISwitch *)sender;
    if (waitingSwitch.on)
    {
        [self.waitingChargeTxt setHidden:false];
    }
    else {
        [self.waitingChargeTxt setHidden:true];
    }
}

- (IBAction)resetValues:(id)sender {
    [self.srcSearchBar setText:@""];
    [self.destSearchBar setText:@""];
    [self.mapView removeAnnotations:[self.mapView annotations]];
    [self.fareLbl setText:@""];
    [self.fareText setHidden:YES];
    [self.fareChart setHidden:YES];
  //  self.travelDate.date = [NSDate date];
    [self.waitingChargeTxt setText:@""];
    [self.mapView removeOverlays:self.mapView.overlays];
}

- (IBAction)calculateFare:(id)sender {
    
    if ([self.srcSearchBar.text isEqualToString:@"" ]|| [self.destSearchBar.text isEqualToString:@""]) {
        UIAlertView *ErrorAlert = [[UIAlertView alloc] initWithTitle:@"Error!!"
                                                         message:@"Please enter src and destination text feilds." delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil, nil];
    [ErrorAlert show];
    }
    else
    {
         [self calculateDistance];
        [self.fareChart setHidden:NO];
    }
}

-(void)calculateDistance
{
    NSString *baseUrl = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=true", self.srcLoc.latitude,self.srcLoc.longitude,self.destLoc.latitude, self.destLoc.longitude];
    
    NSURL *url = [NSURL URLWithString:[baseUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
       
        NSError *error = nil;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];

        NSMutableArray * distanceArr = [[NSMutableArray alloc]init];
       
        
        
        NSMutableArray * durationArr = [[NSMutableArray alloc]init];
        NSArray *routes = [result objectForKey:@"routes"];
        NSDictionary *firstRoute = [routes objectAtIndex:0];
        NSDictionary *leg =  [[firstRoute objectForKey:@"legs"] objectAtIndex:0];
        
        
        distanceArr = [leg objectForKey:@"distance"];
        durationArr = [leg objectForKey:@"duration"];
        
        NSManagedObjectContext * context = [self managedObjectContext];
        NSManagedObject * travelInfo = [NSEntityDescription insertNewObjectForEntityForName:@"TravelInfo" inManagedObjectContext:context];
        
        [travelInfo setValue:[distanceArr valueForKey:@"value"] forKey:@"distance"];
        [travelInfo setValue:[durationArr valueForKey:@"text"] forKey:@"duration"];
        [travelInfo setValue:self.srcSearchBar.text forKey:@"source"];
        [travelInfo setValue:self.destSearchBar.text  forKey:@"destination"];
        [travelInfo setValue:self.travelDate forKey:@"travelDate"];
        [travelInfo setValue:[NSNumber numberWithDouble:self.srcLoc.latitude] forKey:@"srcCoordinateLat"];
        [travelInfo setValue:[NSNumber numberWithDouble:self.srcLoc.longitude] forKey:@"srcCoordinateLong"];
        [travelInfo setValue:[NSNumber numberWithDouble:self.destLoc.latitude] forKey:@"destCoordinateLat"];
        [travelInfo setValue:[NSNumber numberWithDouble:self.destLoc.longitude] forKey:@"destCoordinateLong"];

        
        if (![context save:&error]) {
            NSLog(@"error : %@",[error description]);
            
        }
        float distInKms = [[travelInfo valueForKey:@"distance"] floatValue]/1000;
        self.distance = distInKms;
        [self calculateFareForTaxiCompanyWithDistance:distInKms];
    }];
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


-(void)calculateFareForTaxiCompanyWithDistance:(float)distance
{
    NSDateComponents *component = [[NSCalendar currentCalendar] components:(NSCalendarUnitMonth | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitWeekday) fromDate:self.travelDate];
    NSInteger hours = [component hour];
    NSInteger day = [component weekday];
    BOOL isDay;
    if (hours >= 22 || hours < 6 ) {
        isDay = false;
    }
    else{
        isDay = true;
    }
    int waitingTime = [self.waitingChargeTxt.text integerValue];
    
    float totalTaxiFare,govtFare;
    NSManagedObjectContext * context = [self managedObjectContext];

    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"TaxiCompany"];

    NSArray * taxiInfoArr = [[NSArray alloc]initWithArray:[context executeFetchRequest:fetchRequest error:nil] ];
    NSLog(@"[taxiInfoArr count]: %lu",(unsigned long)[taxiInfoArr count]);
    for (NSUInteger i=0; i<[taxiInfoArr count]; i++) {
        NSManagedObject * taxiInfoObj = [taxiInfoArr objectAtIndex:i];
        NSString * taxiCompanyName = [taxiInfoObj valueForKey:@"companyName"];
        
        if ([taxiCompanyName isEqualToString:@"Taxis Combined"]) {
            if (isDay == true) {
                totalTaxiFare = [[taxiInfoObj valueForKey:@"bookingFee"]floatValue] + [[taxiInfoObj valueForKey:@"hiringCharge"]floatValue] + ([[taxiInfoObj valueForKey:@"dayDistRate"]floatValue] * distance ) + waitingTime*[[taxiInfoObj valueForKey:@"waitingCharge"]floatValue];
            }else{
                if (day == 6 || day == 7 || day == 1) {
                    totalTaxiFare = [[taxiInfoObj valueForKey:@"bookingFee"]floatValue] + [[taxiInfoObj valueForKey:@"hiringChargeSpl"]floatValue] + ([[taxiInfoObj valueForKey:@"nightDistRate"]floatValue] * distance) + waitingTime*[[taxiInfoObj valueForKey:@"waitingCharge"]floatValue];

                }
                totalTaxiFare = [[taxiInfoObj valueForKey:@"bookingFee"]floatValue] + [[taxiInfoObj valueForKey:@"hiringCharge"]floatValue] + ([[taxiInfoObj valueForKey:@"nightDistRate"]floatValue] * distance) + waitingTime*[[taxiInfoObj valueForKey:@"waitingCharge"]floatValue];
                
            }
            govtFare = totalTaxiFare;
        }
        else if ([taxiCompanyName isEqualToString:@"Manly Cabs"]) {
            if (isDay == true) {
                totalTaxiFare = [[taxiInfoObj valueForKey:@"bookingFee"]floatValue] + [[taxiInfoObj valueForKey:@"hiringCharge"]floatValue] + ([[taxiInfoObj valueForKey:@"dayDistRate"]floatValue] * distance )+ waitingTime*[[taxiInfoObj valueForKey:@"waitingCharge"]floatValue];
            }else{
                totalTaxiFare = [[taxiInfoObj valueForKey:@"bookingFee"]floatValue] + [[taxiInfoObj valueForKey:@"hiringCharge"]floatValue] + ([[taxiInfoObj valueForKey:@"nightDistRate"]floatValue] * distance)+ waitingTime*[[taxiInfoObj valueForKey:@"waitingCharge"]floatValue];
                totalTaxiFare = totalTaxiFare + totalTaxiFare*0.20;
            }
        }
        
        else if ([taxiCompanyName isEqualToString:@"St George Cabs"]) {
            if (isDay == true) {
                totalTaxiFare = [[taxiInfoObj valueForKey:@"bookingFee"]floatValue] + [[taxiInfoObj valueForKey:@"hiringCharge"]floatValue] + ([[taxiInfoObj valueForKey:@"dayDistRate"]floatValue] * distance )+ waitingTime*[[taxiInfoObj valueForKey:@"waitingCharge"]floatValue];
            }else{
                totalTaxiFare = [[taxiInfoObj valueForKey:@"bookingFee"]floatValue] + [[taxiInfoObj valueForKey:@"hiringCharge"]floatValue] + ([[taxiInfoObj valueForKey:@"dayDistRate"]floatValue] * distance)+ waitingTime*[[taxiInfoObj valueForKey:@"waitingCharge"]floatValue];
                
            }
        }

        [taxiInfoObj setValue:[NSNumber numberWithFloat:totalTaxiFare ] forKey:@"grossRate"];
    }
    [self.fareText setHidden:NO];
    [self.fareLbl setText:[NSString stringWithFormat:@"$%.2f",govtFare]];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)changeDate:(UIDatePicker *)sender {
    NSLog(@"New Date: %@", sender.date);
    self.travelDate = sender.date;
}

- (void)removeViews:(id)object {
    [[self.view viewWithTag:9] removeFromSuperview];
    [[self.view viewWithTag:10] removeFromSuperview];
    [[self.view viewWithTag:11] removeFromSuperview];
}

- (void)dismissDatePicker:(id)sender {
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height, 320, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height+44, 320, 216);
    [UIView beginAnimations:@"MoveOut" context:nil];
    [self.view viewWithTag:9].alpha = 0;
    [self.view viewWithTag:10].frame = datePickerTargetFrame;
    [self.view viewWithTag:11].frame = toolbarTargetFrame;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeViews:)];
    [UIView commitAnimations];
}

- (IBAction)selectDate:(id)sender {
    if ([self.view viewWithTag:9]) {
        return;
    }
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height-216-44, 320, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height-216, 320, 216);
    
    UIView *darkView = [[UIView alloc] initWithFrame:self.view.bounds];
    darkView.alpha = 0;
    darkView.backgroundColor = [UIColor blackColor];
    darkView.tag = 9;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDatePicker:)] ;
    [darkView addGestureRecognizer:tapGesture];
    [self.view addSubview:darkView];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height+44, 320, 216)];
    datePicker.tag = 10;
    datePicker.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:30];
    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    [comps setYear:0];
    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    
    [datePicker setMaximumDate:maxDate];
    [datePicker setMinimumDate:minDate];
    
    
    [datePicker addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];
    
    
    [self.view addSubview:datePicker];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 44)];
    toolBar.tag = 11;
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissDatePicker:)];
    [toolBar setItems:[NSArray arrayWithObjects:spacer, doneButton, nil]];
    [self.view addSubview:toolBar];
    
    [UIView beginAnimations:@"MoveIn" context:nil];
    toolBar.frame = toolbarTargetFrame;
    datePicker.frame = datePickerTargetFrame;
    darkView.alpha = 0.5;
    [UIView commitAnimations];

}
@end
