//
//  CheckFareViewController.h
//  MapSearch
//
//  Created by Nidhi on 02/08/15.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface CheckFareViewController : UIViewController <UISearchBarDelegate, MKMapViewDelegate,UITextFieldDelegate, UIPickerViewDelegate,UIPickerViewDataSource, UIPopoverPresentationControllerDelegate>
@property (strong, nonatomic) IBOutlet UISearchBar *srcSearchBar;
@property (strong, nonatomic) IBOutlet UISearchBar *destSearchBar;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) MKPointAnnotation * srcAnnotation;
@property (strong, nonatomic) MKPointAnnotation * destAnnotation;
//@property (strong, nonatomic) IBOutlet UIDatePicker *travelDate;
@property (strong, nonatomic) IBOutlet UIButton *getEstimateBtn;
@property (strong, nonatomic) IBOutlet UILabel *fareLbl;
@property (strong, nonatomic) IBOutlet UILabel *fareText;



- (IBAction)fareChart:(id)sender;

- (IBAction)waitingChargeSwitch:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *waitingChargeTxt;
@property (strong, nonatomic) IBOutlet UIButton *fareChart;
@property (strong, nonatomic) IBOutlet UIButton *resetBtn;

- (IBAction)resetValues:(id)sender;
- (IBAction)calculateFare:(id)sender;
-(float)calculateTotalFareForTaxiCompany:(NSString *)taxiCompany;

@end
