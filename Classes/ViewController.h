//
//  ViewController.h
//  TaxiMeter
//
//  Created by Nidhi on 15/07/15.
//  Copyright (c) 2015 ShetCo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowDetViewController.h"
#import "CalculateFareViewController.h"

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *counter;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSString *currentTime;
@property (strong, nonatomic) NSDate *currentDate;
@property (strong, nonatomic) IBOutlet UIButton *check_rate;
@property (strong, nonatomic) IBOutlet UIButton *calculate_trip;
@property (strong, nonatomic) IBOutlet UIButton *track_trip;
@property (strong, nonatomic) IBOutlet UIButton *contact_us;

- (IBAction)stopTime:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;
@property (weak, nonatomic) IBOutlet UILabel *travelledTime;
@end

