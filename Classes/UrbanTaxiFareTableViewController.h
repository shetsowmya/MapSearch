//
//  UrbanTaxiFareTableViewController.h
//  MapSearch
//
//  Created by Nidhi on 30/07/15.
//
//

#import <UIKit/UIKit.h>

@interface UrbanTaxiFareTableViewController : UITableViewController
@property (strong,nonatomic) NSMutableDictionary * taxiFareUrban;
@property(nonatomic) UILineBreakMode lineBreakMode;

@end
@interface MultiColumnTableViewCell : UITableViewCell
@property (strong, nonatomic) UILabel *label1;
@property (strong, nonatomic) UILabel *label2;
@end