//
//  ServiceProviderTableViewController.h
//  MapSearch
//
//  Created by Nidhi on 03/08/15.
//
//

#import <UIKit/UIKit.h>



@interface MyButton : UIButton
{
    NSString *_phone;
}

@property (nonatomic, retain) NSString *phone;
@end

@interface ServiceProviderTableViewController : UITableViewController
- (IBAction)backBtn:(id)sender;

@end
@interface ServiceMultiColumnTableViewCell : UITableViewCell
@property (strong, nonatomic) UILabel *label1;
@property (strong, nonatomic) UILabel *label2;
@property (strong, nonatomic) UILabel *label3;
@property (strong, nonatomic) MyButton * phoneBtn;

@end
