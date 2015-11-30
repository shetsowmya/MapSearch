//
//  ViewController.m
//  TaxiMeter
//
//  Created by Nidhi on 15/07/15.
//  Copyright (c) 2015 ShetCo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (atomic) BOOL clockTicks;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setTimeStyle: NSDateFormatterMediumStyle ];
    
//    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Taxi_4.png"]];
//    
//    self.view.backgroundColor = background;

    [self.check_rate setBackgroundImage:[UIImage imageNamed:@"Taxi_CheckRate.png"]forState:UIControlStateNormal];
    
    [self.calculate_trip setBackgroundImage:[UIImage imageNamed:@"Taxi_CalculateTrip.png"]forState:UIControlStateNormal];
    
    [self.track_trip setBackgroundImage:[UIImage imageNamed:@"Taxi_TrackTrip.png"]forState:UIControlStateNormal];
    [self.contact_us setBackgroundImage:[UIImage imageNamed:@"Taxi_ContactUs.png"]forState:UIControlStateNormal];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Home.png"]];

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startTime:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle: NSDateFormatterShortStyle];
    
    [self.stopBtn setEnabled:TRUE];
    
    self.clockTicks = true;
    if (self.clockTicks == true) {
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(targetMethod:)
                                   userInfo:nil
                                    repeats:YES];
    }
}

- (IBAction)stopTime:(id)sender {
    NSString *stoppedTime = [_dateFormatter stringFromDate: [NSDate date]];
    NSDate * stoppedDate = [NSDate date];
    self.counter.text = stoppedTime;
    self.clockTicks = false;
    [self.stopBtn setEnabled:FALSE];
    
    
    unsigned int unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitSecond;
    
    NSCalendar * currCalendar = [NSCalendar currentCalendar];
    NSDateComponents *conversionInfo = [currCalendar components:unitFlags fromDate:_currentDate   toDate:stoppedDate  options:0];
    
    NSInteger months = [conversionInfo month];
    NSInteger days = [conversionInfo day];
    NSInteger hours = [conversionInfo hour];
    NSInteger minutes = [conversionInfo minute];
    NSInteger secs = [conversionInfo second];
    NSDateComponentsFormatter *df = [[NSDateComponentsFormatter alloc] init];
    df.unitsStyle = NSDateComponentsFormatterUnitsStylePositional;
    df.allowedUnits =  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSString *dateString = [df stringFromDate:_currentDate toDate:stoppedDate];
    NSLog(@"date Str : %@",dateString);
    
    NSLog(@"current time : %@, stopped time : %@",_currentDate, stoppedDate);
    NSLog(@"times : %ld,%ld,%ld,%ld, %d",(long)months,(long)days,(long)hours,(long)minutes, secs);
    
    NSString * travelledTime = [NSString stringWithFormat:@"%ld hrs:%ld mins:%ld secs",(long)hours,(long)minutes, (long)secs];
    self.travelledTime.text = travelledTime;
}

-(void)targetMethod:(id)sender
{
    
    _currentTime = [_dateFormatter stringFromDate: [NSDate date]];
    
    _currentDate = [NSDate date];
    if (self.clockTicks == true) {
        self.counter.text = _currentTime;
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



@end
