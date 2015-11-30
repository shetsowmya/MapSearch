//
//  ShowTravelDetailsTableViewController.m
//  MapSearch
//
//  Created by Nidhi on 10/09/15.
//
//

#import "ShowTravelDetailsTableViewController.h"

@interface ShowTravelDetailsTableViewController ()

@property NSMutableArray * instructionsArr;
@property NSMutableArray * distanceArr;


@end

@implementation ShowTravelDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setDelegate:self];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.routeStepsArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    
    NSLog(@"distance : %f",[[self.routeStepsArr objectAtIndex:indexPath.row] distance]);
    CLGeocoder * fgeo = [[CLGeocoder alloc]init];
    
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.numberOfLines = 0;
    
    if (indexPath.row == 0) {
//        CLLocation *sLoc = [[CLLocation alloc] initWithCoordinate:self.srcLoc altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];
//        
//        [fgeo reverseGeocodeLocation:sLoc
//                   completionHandler:^(NSArray *placemarks, NSError *error){
//                       if(!error){
//                           CLPlacemark *placemark = [placemarks objectAtIndex:0];
//                           self.srcAddress = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
//                       }
//                   }
//         ];
        
        [cell.imageView setImage:[UIImage imageNamed:@"pinGreen.png"]];
        cell.textLabel.text = self.srcAddress;
        cell.detailTextLabel.text = @"";
    }
    else if(indexPath.row == (self.routeStepsArr.count -1))
    {
        
//         CLLocation *dLoc = [[CLLocation alloc] initWithCoordinate:self.destLoc altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];
//        [fgeo reverseGeocodeLocation:dLoc
//                   completionHandler:^(NSArray *placemarks, NSError *error){
//                       if(!error){
//                           CLPlacemark *placemark = [placemarks objectAtIndex:0];
//                           self.destAddress = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
//                       }
//                   }
//         ];
        [cell.imageView setImage:[UIImage imageNamed:@"pinRed.png"]];
        cell.textLabel.text = self.destAddress;
        cell.detailTextLabel.text = @"";

    }
    else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%0.0f m",[[self.routeStepsArr objectAtIndex:indexPath.row] distance]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:25];
            NSString * instructionStr = [[self.routeStepsArr objectAtIndex:indexPath.row] instructions];
        cell.detailTextLabel.text = instructionStr;
        
        
        if (([instructionStr rangeOfString:@"destination"].length != 0) && ([instructionStr rangeOfString:@"right"].length != 0)){
            cell.imageView.image = [UIImage imageNamed:@"dest_right.png"];
        }
        else if (([instructionStr rangeOfString:@"destination"].length != 0) && ([instructionStr rangeOfString:@"left"].length != 0)){
            cell.imageView.image = [UIImage imageNamed:@"dest_on_left.png"];
        }
        else if ([instructionStr rangeOfString:@"destination"].length){
            cell.imageView.image = [UIImage imageNamed:@"destination.png"];
        }
        else if (([instructionStr rangeOfString:@"roundabout"].length) && ([instructionStr rangeOfString:@"second exit"].length)){
            cell.imageView.image = [UIImage imageNamed:@"second_roundAbt.png"];
        }
        else if (([instructionStr rangeOfString:@"roundabout"].length) && ([instructionStr rangeOfString:@"first exit"].length)){
            cell.imageView.image = [UIImage imageNamed:@"first_roundAbt.png"];
        }
        else if ([instructionStr rangeOfString:@"right"].length != 0) {
            cell.imageView.image = [UIImage imageNamed:@"right.png"];
        }
        else if ([instructionStr rangeOfString:@"left"].length != 0) {
            cell.imageView.image = [UIImage imageNamed:@"left.png"];
        }
        else if ([instructionStr rangeOfString:@"keep right"].length != 0) {
            cell.imageView.image = [UIImage imageNamed:@"keep_right.png"];
        }
        else if ([instructionStr rangeOfString:@"roundabout"].length){
            cell.imageView.image = [UIImage imageNamed:@"second_roundAbt.png"];
        }

    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"reaching accessoryButtonTappedForRowWithIndexPath:");
    //[self performSegueWithIdentifier:@"modaltodetails" sender:[self.eventsTable cellForRowAtIndexPath:indexPath]];
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
