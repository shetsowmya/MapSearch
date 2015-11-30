//
//  ShowTravelDetailsTableViewController.h
//  MapSearch
//
//  Created by Nidhi on 10/09/15.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CLGeocoder.h>

#import <CoreLocation/CoreLocation.h>


@interface ShowTravelDetailsTableViewController : UITableViewController
@property (strong) NSMutableArray * routeStepsArr;
@property CLLocationCoordinate2D srcLoc, destLoc;
@property NSString *srcAddress, *destAddress;
@end
