//
//  ServiceProviderTableViewController.m
//  MapSearch
//
//  Created by Nidhi on 03/08/15.
//
//

#import "ServiceProviderTableViewController.h"



@interface ServiceProviderTableViewController ()
@property (strong) NSArray * companies;
@end

@interface ServiceMultiColumnTableViewCell ()
@property (strong, nonatomic) UIView *divider1;
@property (strong, nonatomic) UIView *divider2;

@end

@implementation MyButton
@synthesize phone = _phone;


@end

@implementation ServiceMultiColumnTableViewCell

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

-(MyButton *)button{
    MyButton * button = [[MyButton alloc]init];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:button];
    return button;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.separatorInset = UIEdgeInsetsZero;
    //self.layoutMargins = UIEdgeInsetsZero;
    //self.preservesSuperviewLayoutMargins = NO;
    
    self.divider1 = [self divider];
    self.divider2 = [self divider];
    
    self.label1 = [self label];
    self.label2 = [self label];
    self.label3 = [self label];
    self.phoneBtn = [self button];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_label1, _label2, _phoneBtn, _divider1, _divider2);
    
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[_label1]-2-[_divider1]-2-[_label2(==_label1)]-2-[_divider2]-10-[_phoneBtn(==_label1)]-5-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views];
    NSArray *horizontalConstraints1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_divider1]|" options:0 metrics:nil views:views];
    [self.contentView addConstraints:horizontalConstraints1];
    NSArray *horizontalConstraints2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_divider2]|" options:0 metrics:nil views:views];
    [self.contentView addConstraints:horizontalConstraints2];
    
    [self.contentView addConstraints:constraints];
    
    
    return self;
}
@end

@implementation ServiceProviderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[ServiceMultiColumnTableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.separatorColor = [UIColor lightGrayColor];

    [self.tableView setContentInset:UIEdgeInsetsMake(20,0,0,0)];
    
    NSManagedObjectContext * context = [self managedObjectContext];
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"TaxiCompany"];
    
    self.companies = [context executeFetchRequest:fetchRequest error:nil];
    
    [self.tableView reloadData];

    
    
   // self.tableView.rowHeight = 44;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSManagedObjectContext * context = [self managedObjectContext];
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"TaxiCompany"];
    
    self.companies = [context executeFetchRequest:fetchRequest error:nil];

    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.companies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSManagedObject * managedObject = [self.companies objectAtIndex:indexPath.row];
    
    
    ServiceMultiColumnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.label1.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    cell.label2.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    cell.label3.font = [UIFont fontWithName:@"Helvetica" size:10.0];

    cell.label1.lineBreakMode = NSLineBreakByCharWrapping;
    cell.label2.lineBreakMode = NSLineBreakByCharWrapping; // Pre-iOS6 use UILineBreakModeWordWrap
    
    cell.label2.numberOfLines = 0;
    cell.label1.text = [managedObject valueForKey:@"companyName"];
    
    
    NSString * phoneNo = [managedObject valueForKey:@"contactNo"];
    
    cell.label2.text = [[managedObject valueForKey:@"grossRate"] stringValue];
    [cell.phoneBtn setTitle:@"call" forState:UIControlStateNormal];
    [cell.phoneBtn setBackgroundImage:[UIImage imageNamed:@"green-phone-symbol.jpg"] forState:UIControlStateNormal];
    
   [cell.phoneBtn addTarget:self
                     action:@selector(aMethod:)
           forControlEvents:UIControlEventTouchUpInside];
    
    [cell.phoneBtn setPhone:phoneNo];
    return cell;

}

-(void)aMethod:(MyButton *)sender
{
    NSString * phoneNo = [NSString stringWithFormat:@"tel://%@",sender.phone];
    NSLog(@"phoneNo : %@",phoneNo);
    UIApplication  * myApp = [UIApplication sharedApplication];
    [myApp openURL:[NSURL URLWithString:phoneNo]];
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

- (IBAction)backBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
