//
//  RuralTaxiFareTableViewController.m
//  MapSearch
//
//  Created by Nidhi on 30/07/15.
//
//

#import "RuralTaxiFareTableViewController.h"

@interface RuralTaxiFareTableViewController ()

@end

@interface RuralMultiColumnTableViewCell ()
@property (strong, nonatomic) UIView *divider1;
@end

@implementation RuralMultiColumnTableViewCell

- (UILabel *)label {
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:label];
    return label;
}

- (UIView *)divider {
    UIView *view = [[UIView alloc] init];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:1.0/[[UIScreen mainScreen] scale]]];
    view.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:view];
    return view;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.separatorInset = UIEdgeInsetsZero;
   // self.layoutMargins = UIEdgeInsetsZero;
   // self.preservesSuperviewLayoutMargins = NO;
    
    self.divider1 = [self divider];
    
    self.label1 = [self label];
    self.label2 = [self label];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_label1, _label2, _divider1);
    
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[_label1]-2-[_divider1]-2-[_label2(==_label1)]-5-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views];
    [self.contentView addConstraints:constraints];
    
    NSArray *horizontalConstraints1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_divider1]|" options:0 metrics:nil views:views];
    [self.contentView addConstraints:horizontalConstraints1];
    
    return self;
}
@end

@implementation RuralTaxiFareTableViewController
@synthesize taxiFareRural;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Home_Template.png"]];
    
    [self.tableView registerClass:[RuralMultiColumnTableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.separatorColor = [UIColor lightGrayColor];
    taxiFareRural = [[NSMutableDictionary alloc]init];
    [taxiFareRural setValue:@"$4.10" forKey:@"Hiring Charge"];
    [taxiFareRural setValue:@"$2.26 per kilometre, for the first 12 km\nRate 2 – $3.13 per kilometre, in excess of 12 km" forKey:@"Distance Rate"];
    [taxiFareRural setValue:@"$2.71 per kilometre, for the first 12 km\n$3.75 per kilometre, in excess of 12 km" forKey:@"Holiday Distance Rate and Night Distance Rate"];
    [taxiFareRural setValue:@"$1.20" forKey:@"Booking Fee"];
    [taxiFareRural setValue:@"96.0c per minute ($57.65 per hour) while vehicle speed is less than 26 km/h" forKey:@"Waiting Time"];

    //UIView * polygonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
    //[ self.view addSubview:polygonView];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

    /*- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0                ;
}*/                                                             

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [taxiFareRural count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 RuralMultiColumnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.label1.font = [UIFont fontWithName:@"Helvetica" size:13.0];
    cell.label2.font = [UIFont fontWithName:@"Helvetica" size:13.0];
    cell.label2.lineBreakMode = NSLineBreakByCharWrapping; // Pre-iOS6 use UILineBreakModeWordWrap
    NSArray* arrayOfKeys, *allValues;
    cell.label2.numberOfLines = 0;
    arrayOfKeys = [taxiFareRural allKeys];
    allValues = [taxiFareRural allValues];
    cell.label1.text = [arrayOfKeys objectAtIndex:indexPath.row];
    cell.label2.text = [allValues objectAtIndex:indexPath.row];

    return cell;
 }

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
