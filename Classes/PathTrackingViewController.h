//
//  PathTrackingViewController.h
//  MapSearch
//
//  Created by Nidhi on 14/09/15.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@interface PathTrackingViewController : UIViewController <CLLocationManagerDelegate,MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *routeMap;
@property CLLocationCoordinate2D * stepCoordinates;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) MKPointAnnotation * srcAnnotation;
@property (strong, nonatomic) MKPointAnnotation * destAnnotation;
@property CLLocationCoordinate2D srcLocation;
@property CLLocationCoordinate2D destLocation;
@property (strong, retain) NSMutableArray * instructionsArr;
@property (strong, retain) NSMutableArray * steps;

@end
