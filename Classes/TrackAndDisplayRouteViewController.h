//
//  TrackAndDisplayRouteViewController.h
//  MapSearch
//
//  Created by Nidhi on 22/08/15.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ShowTravelDetailsTableViewController.h"
#import "PathTrackingViewController.h"
//#import "CrumbPath.h"
//#import "CrumbPathRenderer.h"


/*@interface MyOverlay1 : NSObject <MKOverlay>
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) MKMapRect boundingMapRect;
@property (nonatomic,readwrite) UIBezierPath * path;
- (id) initWithRect: (MKMapRect) rect;
@end

@implementation MyOverlay1
- (id) initWithRect: (MKMapRect) rect {
    self = [super init];
    if (self) {
        self->_boundingMapRect = rect;
    }
    return self;
}
- (CLLocationCoordinate2D) coordinate {
    MKMapPoint pt = MKMapPointMake(
                                   MKMapRectGetMidX(self.boundingMapRect),
                                   MKMapRectGetMidY(self.boundingMapRect));
    return MKCoordinateForMapPoint(pt);
}
@end
*/
@interface AddressAnnotation1 : NSObject<MKAnnotation> {
}
@property (nonatomic, retain) NSNumber *pinNumber;
@end

@interface TrackAndDisplayRouteViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *routeMap;
@property (strong, nonatomic) MKPointAnnotation * srcAnnotation;
@property (strong, nonatomic) MKPointAnnotation * destAnnotation;
@property CLLocationCoordinate2D srcLocation;
@property CLLocationCoordinate2D destLocation;
@property (strong, retain) NSMutableArray * instructionsArr;
@property (strong, retain) NSMutableArray * steps;

@property (strong, nonatomic) IBOutlet UIButton *showDetails;
@property (strong, nonatomic) IBOutlet UILabel *longitude;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UILabel *latitude;
@property CLLocationCoordinate2D * stepCoordinates;
- (IBAction)showDetails:(id)sender;

@end
