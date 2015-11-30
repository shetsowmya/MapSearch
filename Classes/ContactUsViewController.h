//
//  ContactUsViewController.h
//  MapSearch
//
//  Created by Nidhi on 13/09/15.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>


@interface ContactUsViewController : UIViewController <MFMailComposeViewControllerDelegate>
- (IBAction)emailUs:(id)sender;
- (IBAction)openWebsite:(id)sender;
- (IBAction)callUs:(id)sender;
- (IBAction)rateUs:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *emailBtn;
@property (strong, nonatomic) IBOutlet UIButton *websiteBtn;
@property (strong, nonatomic) IBOutlet UIButton *callBtn;
@property (strong, nonatomic) IBOutlet UIButton *rateBtn;

@end
