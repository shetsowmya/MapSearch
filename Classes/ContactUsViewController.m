//
//  ContactUsViewController.m
//  MapSearch
//
//  Created by Nidhi on 13/09/15.
//
//

#import "ContactUsViewController.h"

@interface ContactUsViewController ()

@end

@implementation ContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Home_Template.png"]];

    self.emailBtn.layer.cornerRadius = 6;
    self.emailBtn.layer.borderWidth = 1;
    self.emailBtn.layer.borderColor = [UIColor colorWithRed:148 green:0 blue:226 alpha:1].CGColor;
    
    self.websiteBtn.layer.cornerRadius = 6;
    self.websiteBtn.layer.borderWidth = 3;
    self.websiteBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.callBtn.layer.cornerRadius = 6;
    self.callBtn.layer.borderWidth = 3;
    self.callBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.rateBtn.layer.cornerRadius = 6;
    self.rateBtn.layer.borderWidth = 3;
    self.rateBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.emailBtn.layer.cornerRadius = 6;
    self.emailBtn.layer.borderWidth = 3;
    self.emailBtn.layer.borderColor = [UIColor colorWithRed:148 green:0 blue:226 alpha:1].CGColor;
    
    self.emailBtn.layer.cornerRadius = 6;
    self.emailBtn.layer.borderWidth = 3;
    self.emailBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)sendMail
{
    NSString * emailTitle = @"Details";
    NSArray * toRecipents = [NSArray arrayWithObject:@"shetsowmya@gmail.com"];
    
    MFMailComposeViewController * mailComposer = [[MFMailComposeViewController alloc]init];
    if ([MFMailComposeViewController canSendMail]) {
        
        
        mailComposer.mailComposeDelegate = self;
        
        [mailComposer setSubject:emailTitle];
        [mailComposer setToRecipients:toRecipents];
        [self presentViewController:mailComposer animated:YES completion:nil];
    }
}


-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSLog(@"delegate called");
    switch (result) {
        case MFMailComposeResultCancelled:
            [self mailAlertMessage:@"Message sending cancelled" title:@"Alert"];
            
            NSLog(@"Mail cancelled");
            break;
            
        case MFMailComposeResultFailed:
            [self mailAlertMessage:@"Message sending failed" title:@"Alert"];
            
            NSLog(@"Mail failed");
            break;
            
            
        case MFMailComposeResultSaved:
            [self mailAlertMessage:@"Your Message is saved" title:@"Alert"];
            NSLog(@"Mail saved");
            break;
            
            
        case MFMailComposeResultSent:
            [self mailAlertMessage:@"Your Message has been sent" title:@"Alert"];
            NSLog(@"Mail sent");
            break;
            
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)mailAlertMessage:(NSString *)message1 title:(NSString *)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message1 delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
    
}


- (IBAction)emailUs:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
        [self sendMail];


}

- (IBAction)openWebsite:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                    message:@"Website under construction" delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

- (IBAction)callUs:(id)sender {
    NSString * phoneNo = @"9844763905";
    NSString * theCall = [NSString stringWithFormat:@"tel://%@",phoneNo];
    
    UIApplication  * myApp = [UIApplication sharedApplication];
    [myApp openURL:[NSURL URLWithString:theCall]];
}

- (IBAction)rateUs:(id)sender {
}
@end
