//
//  UrbanTaxiFareTableViewController.h
//  MapSearch
//
//  Created by Nidhi on 30/07/15.
//
//

#import <UIKit/UIKit.h>

@interface RuralTaxiFareTableViewController : UITableViewController
@property (strong,nonatomic) NSMutableDictionary * taxiFareRural;
@property(nonatomic) UILineBreakMode lineBreakMode;

@end
@interface RuralMultiColumnTableViewCell : UITableViewCell
@property (strong, nonatomic) UILabel *label1;
@property (strong, nonatomic) UILabel *label2;
@end