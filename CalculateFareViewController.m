//
//  CalculateFareViewController.m
//  MapSearch
//
//  Created by Nidhi on 08/03/15.
//
//

#import "CalculateFareViewController.h"

@interface CalculateFareViewController ()

@end

@implementation CalculateFareViewController

@synthesize waitingTime,autoFare,distanceTravelled,totalCost;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self displayDistance];
        // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void) displayDistance
{
    _totaldistance = 0;
    for (NSUInteger i=0; i<[_distanceArr count]; i++) {
        NSDictionary * dict = [_distanceArr objectAtIndex:i];
        int value = [[dict objectForKey:@"value"] intValue];
        _totaldistance = _totaldistance + value;
    }
    _totaldistance = _totaldistance/1000;
    distanceTravelled.text = [NSString stringWithFormat:@"%0.02f kms",_totaldistance];
}

-(void)calculateTotalCost
{
    float total = 0;
    
    if (_totaldistance <= 2) {
        total = 25 + _waitingCharge;
        totalCost.text = @"25";
    }
    else
    {
        total = 25 + ((_totaldistance-2) * 11) + _waitingCharge;
    }
    totalCost.text = [NSString stringWithFormat:@"Total Cost : %0.02f Rs",total];
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    _waitingCharge = [textField.text intValue] * 2;
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
    
}

- (IBAction)calculateTotalCost:(id)sender {
    if (![waitingTime.text isEqual:@""]) {
        
    [self calculateTotalCost];
    }
    else{
        UIAlertView *ErrorAlert = [[UIAlertView alloc] initWithTitle:@"Error!!"
                                                             message:@"Please enter waiting time." delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil, nil];
        [ErrorAlert show];
   
    }
}
@end
