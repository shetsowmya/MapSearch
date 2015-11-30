//
//  CalculateFareViewController.h
//  MapSearch
//
//  Created by Nidhi on 08/03/15.
//
//

#import <UIKit/UIKit.h>

@interface CalculateFareViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *distanceTravelled;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *autoFare;
@property (weak, nonatomic) IBOutlet UITextField *waitingTime;
@property (weak, nonatomic) IBOutlet UILabel *totalCost;

- (IBAction)calculateTotalCost:(id)sender;
@property (strong,nonatomic) NSArray * distanceArr;
@property int waitingCharge;
@property float totaldistance;
@end
