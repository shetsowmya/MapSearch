//
//  TaxiCompaniesViewController.h
//  MapSearch
//
//  Created by Nidhi on 29/07/15.
//
//

#import <UIKit/UIKit.h>

@interface UrbanTaxiCompaniesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    IBOutlet UITextField *companyName;
    NSMutableArray *pastNames;
    NSMutableArray *autocompleteNames;
    UITableView *autocompleteTableView;
}

@property (nonatomic, retain) UITextField *companyName;
@property (nonatomic, retain) NSMutableArray *pastNames;
@property (nonatomic, retain) NSMutableArray *autocompleteNames;
@property (nonatomic, retain) UITableView *autocompleteTableView;
- (IBAction)goPressed:(id)sender;

- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring;

@end
