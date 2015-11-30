/*
     File: MyTableViewController.m
 Abstract: Primary view controller used to display search results.
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

#import "MyTableViewController.h"

#import <MapKit/MapKit.h>

// note: we use a custom segue here in order to cache/reuse the
//       destination view controller (i.e. MapViewController) each time you select a place
//
@interface DetailSegue : UIStoryboardSegue
@end

@implementation DetailSegue

- (void)perform
{
    // our custom segue is being fired, push the map view controller
    MyTableViewController *sourceViewController = self.sourceViewController;
    MapViewController *destinationViewController = self.destinationViewController;
    [sourceViewController.navigationController pushViewController:destinationViewController animated:YES];
}

@end


#pragma mark -

static NSString *kCellIdentifier = @"cellIdentifier";

@interface MyTableViewController ()

@property (nonatomic, assign) MKCoordinateRegion boundingRegion;

@property (nonatomic, strong) MKLocalSearch *localSearch;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *viewAllButton;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) CLLocationCoordinate2D userLocation;

@property (nonatomic, strong) DetailSegue *detailSegue;
@property (nonatomic, strong) DetailSegue *showAllSegue;
@property (nonatomic, strong) MapViewController *mapViewController;


- (IBAction)showAll:(id)sender;

@end


#pragma mark -

@implementation MyTableViewController

bool srcEntered = false;
bool destEntered = false;

@synthesize source,destination;
- (void)viewDidLoad
{
	[super viewDidLoad];
    
  //  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"images (2).jpeg"]];

    //cretating object of MapViewController
//    MapViewController * mapViewController = [[MapViewController alloc] init];
//    mapViewController.delegate = self;
//    [mapViewController testResult];
    
    // start by locating user's current position
	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self;
	[self.locationManager startUpdatingLocation];
    
    // create and reuse for later the mapViewController
    self.mapViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"MapViewControllerID"];
    
    // use our custom segues to the destination view controller is reused
    self.detailSegue = [[DetailSegue alloc] initWithIdentifier:@"showDetail"
                                                              source:self
                                                         destination:self.mapViewController];
    
    self.showAllSegue = [[DetailSegue alloc] initWithIdentifier:@"showAll"
                                                        source:self
                                                   destination:self.mapViewController];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [super viewWillAppear:animated];
    
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated
{
//    
//    NSManagedObjectContext * context = [self managedObjectContext];
//    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"MapInfo"];
//    
//    self.places_1 = [context executeFetchRequest:fetchRequest error:nil];
//
//    
//    NSManagedObject * managedObject = [self.places_1 objectAtIndex:0];
//    NSLog(@"[managedObject valueForKey:%@",[managedObject valueForKey:@"detailedInfo"] );
}

- (NSUInteger)supportedInterfaceOrientations
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return UIInterfaceOrientationMaskAll;
    else
        return UIInterfaceOrientationMaskAllButUpsideDown;
}


#pragma mark - UITableView delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

	return [self.places count] - 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    MKMapItem *mapItem = [self.places objectAtIndex:indexPath.row];
    
        cell.textLabel.text = mapItem.name;

    
        NSArray * placesArray = [mapItem.placemark.addressDictionary objectForKey:@"FormattedAddressLines"];
        NSString * placeString = [placesArray objectAtIndex:0];
    
        for (NSUInteger i=1; i<placesArray.count; i++) {
            placeString = [placeString stringByAppendingString: [NSString stringWithFormat:@", %@",[placesArray objectAtIndex:i]]];
        }
    
        cell.detailTextLabel.text = placeString;
    
    return cell;
}

- (IBAction)showAll:(id)sender
{
    if (!srcEntered || !destEntered) {
        NSString *alertMessage = [NSString stringWithFormat:@"source or destination not entered"];
        
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                        message:alertMessage
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
        [servicesDisabledAlert show];

    }
    else
    {
    // pass the new bounding region to the map destination view controller
        
        
    self.mapViewController.boundingRegion = self.boundingRegion;
    
    //[self.mapViewController.showDet setHidden:FALSE];
    //[self.mapViewController.calcFare setHidden:FALSE];

    // pass the places list to the map destination view controller
    
    self.mapViewController.mapItemList = self
    .source;
    self.mapViewController.mapItemList = [self.mapViewController.mapItemList arrayByAddingObjectsFromArray:self.destination];
    
    [self.showAllSegue perform];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // pass the new bounding region to the map destination view controller
    self.mapViewController.boundingRegion = self.boundingRegion;
    
    // pass the individual place to our map destination view controller
    NSIndexPath *selectedItem = [self.tableView indexPathForSelectedRow];
    
    if ([self.places containsObject:@"sourceSTR#"]) {
        self.source = [NSArray arrayWithObject:[self.places objectAtIndex:selectedItem.row]];
        srcEntered = true;
//        MKMapItem * srcMapItem = [self.places objectAtIndex:selectedItem.row];
//        self.srcCoordinate = srcMapItem.placemark.coordinate;
    }
    else if([self.places containsObject:@"destinationSTR#"])
    {
        self.destination = [NSArray arrayWithObject:[self.places objectAtIndex:selectedItem.row]];
        destEntered = true;
//        MKMapItem * destMapItem = [self.places objectAtIndex:selectedItem.row];
//        self.destCoordinate = destMapItem.placemark.coordinate;

    }
    self.mapViewController.mapItemList = [NSArray arrayWithObject:[self.places objectAtIndex:selectedItem.row]];
    
    self.places = nil;
    [tableView reloadData];
    [self.detailSegue perform];
}


#pragma mark - UISearchBarDelegate

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

- (void)startSearch:(NSString *)searchString ofSearchBar:(UISearchBar *)searchBar
{
    if (self.localSearch.searching)
    {
        [self.localSearch cancel];
    }
    
    // confine the map search area to the user's current location
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = self.userLocation.latitude;
    newRegion.center.longitude = self.userLocation.longitude;
    
    // setup the area spanned by the map region:
    // we use the delta values to indicate the desired zoom level of the map,
    //      (smaller delta values corresponding to a higher zoom level)
    //
    newRegion.span.latitudeDelta = 0.112872;
    newRegion.span.longitudeDelta = 0.109863;
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    
    request.naturalLanguageQuery = searchString;
    request.region = newRegion;
    
    MKLocalSearchCompletionHandler completionHandler = ^(MKLocalSearchResponse *response, NSError *error)
    {
        if (error != nil)
        {
            NSString *errorStr = [[error userInfo] valueForKey:NSLocalizedDescriptionKey];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not find places"
                                                            message:errorStr
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            
            self.places = [response mapItems];
            
            if (searchBar.tag == 1) {
                self.places = [self.places arrayByAddingObject:@"sourceSTR#"];
            }
            else if(searchBar.tag == 2)
            {
                self.places = [self.places arrayByAddingObject:@"destinationSTR#"];
            }
            
            // used for later when setting the map's region in "prepareForSegue"
            self.boundingRegion = response.boundingRegion;
            
            self.viewAllButton.enabled = self.places != nil ? YES : NO;
            
            [self.tableView reloadData];
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    };
    
    if (self.localSearch != nil)
    {
        self.localSearch = nil;
    }
    self.localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    
    [self.localSearch startWithCompletionHandler:completionHandler];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    // check to see if Location Services is enabled, there are two state possibilities:
    // 1) disabled for entire device, 2) disabled just for this app
    //
    
    NSString *causeStr = nil;
    
    // check whether location services are enabled on the device
    if (([CLLocationManager locationServicesEnabled] == NO) && ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied))
    {
        causeStr = @"device";
    }
    // check the application’s explicit authorization status:
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        causeStr = @"app";
    }
    else
    {
        // we are good to go, start the search
        [self startSearch:searchBar.text ofSearchBar:(UISearchBar *)searchBar];
    }
        
    if (causeStr != nil)
    {
        NSString *alertMessage = [NSString stringWithFormat:@"You currently have location services disabled for this %@. Please refer to \"Settings\" app to turn on Location Services.", causeStr];
    
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled"
                                                                            message:alertMessage
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"OK"
                                                                  otherButtonTitles:nil];
        [servicesDisabledAlert show];
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


#pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // remember for later the user's current location
    self.userLocation = newLocation.coordinate;
    
	[manager stopUpdatingLocation]; // we only want one update
    
    manager.delegate = nil;         // we might be called again here, even though wesea
                                    // called "stopUpdatingLocation", remove us as the delegate to be sure
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    // report any errors returned back from Location Services
}



#pragma mark UITextFieldDelegate methods

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    autocompleteTableView.hidden = NO;
//    
//    NSString *substring = [NSString stringWithString:textField.text];
//    substring = [substring stringByReplacingCharactersInRange:range withString:string];
//    [self searchAutocompleteEntriesWithSubstring:substring];
//    return YES;
//}



@end

