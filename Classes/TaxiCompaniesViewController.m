//
//  UrbanTaxiCompaniesViewController.m
//  MapSearch
//
//  Created by Nidhi on 29/07/15.
//
//

#import "TaxiCompaniesViewController.h"

@interface UrbanTaxiCompaniesViewController ()

@end

@implementation UrbanTaxiCompaniesViewController
@synthesize companyName = companyName;
@synthesize pastNames;
@synthesize autocompleteNames;
@synthesize autocompleteTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pastNames = [[NSMutableArray alloc] initWithObjects:@"Taxis Combined", @"Legion Cabs",@"Premier Cabs",@"St George Cabs",@"Manly Cabs",@"Diomond Service",@"Silver Service",@"Sydney Cabbie",nil];
    self.autocompleteNames = [[NSMutableArray alloc] init];
    
    autocompleteTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 180, 320, 120) style:UITableViewStylePlain];
    autocompleteTableView.delegate = self;
    companyName.delegate = self;
    autocompleteTableView.dataSource = self;
    autocompleteTableView.scrollEnabled = YES;
    autocompleteTableView.hidden = YES;
    [self.view addSubview:autocompleteTableView];
    
    

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

- (IBAction)goPressed:(id)sender {
}

- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    
    // Put anything that starts with this substring into the autocompleteUrls array
    // The items in this array is what will show up in the table view
    [autocompleteNames removeAllObjects];
    for(NSString *curString in pastNames) {
        if ([curString caseInsensitiveCompare:substring] == 1) {
            [autocompleteNames addObject:curString];
            
            if ([substring isEqualToString: @""]) {
                [autocompleteNames removeAllObjects];
            }
        }
    }
    [autocompleteTableView reloadData];
    
}

#pragma mark UITextFieldDelegate methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    autocompleteTableView.hidden = NO;
    
    NSString *substring = [NSString stringWithString:textField.text];
    substring = [substring stringByReplacingCharactersInRange:range withString:string];
    [self searchAutocompleteEntriesWithSubstring:substring];
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableVie1qQw numberOfRowsInSection:(NSInteger) section {
    return autocompleteNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
    }
    
    cell.textLabel.text = [autocompleteNames objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    companyName.text = selectedCell.textLabel.text;
    
    //[self goPressed];
    
}


@end
