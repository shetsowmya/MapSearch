//
//  TrackRouteViewController.h
//  MapSearch
//
//  Created by Nidhi on 14/08/15.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "TrackAndDisplayRouteViewController.h"

@interface TrackRouteViewController : UIViewController<UISearchBarDelegate, MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *routeMap;
@property (strong, nonatomic) IBOutlet UISearchBar *srcSearchBar;
@property (strong, nonatomic) IBOutlet UISearchBar *destSearchBar;
@property (strong, nonatomic) MKPointAnnotation * srcAnnotation;
@property (strong, nonatomic) MKPointAnnotation * destAnnotation;
@property (nonatomic,retain) NSMutableArray * detailInfoArray;
@property (nonatomic,retain) NSMutableArray * distanceArray;
@property (nonatomic,retain) NSMutableArray * durationArray;
@property (nonatomic,retain) NSMutableArray * distanceDurationInstructionsArray;
@property (strong, nonatomic) IBOutlet UITextView *routeInfoTxtView;
- (IBAction)TrackLocation:(id)sender;
@property (nonatomic,retain) NSMutableArray * finalResultsArray;
@end
