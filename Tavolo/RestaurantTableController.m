//
//  RestaurantTableController.m
//  Tavolo
//
//  Created by Alex Wright on 4/11/15.
//  Copyright (c) 2015 Tavolo Team. All rights reserved.
//

#import "RestaurantTableController.h"
#import "Customer.h"
#import "RestaurantCell.h"
#import "TavoloTableViewCell.h"
#import <Parse/Parse.h>

@interface RestaurantTableController (){
    NSArray *sectionTitles;
}
@end

@implementation RestaurantTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    sectionTitles = @[@"2 People", @"3 People", @"4 People", @"5+People"];


/*    Customer *cust1 = [[Customer alloc] initWithGuestName:@"Niko" partySize:@"2" tableNum:@"-1"  waitTime:@"10" seated:NO];
    
    Customer *cust2 = [[Customer alloc] initWithGuestName:@"Alex" partySize:@"2" tableNum:@"-1"  waitTime:@"9" seated:NO];*/
    
    _currentParties = [[NSMutableArray alloc] init];
    PFQuery *query =[PFQuery queryWithClassName:@"newQueue"];
    [query whereKey:@"restaurant" equalTo:[PFUser currentUser].objectId];
    [query orderByAscending:@"partySize"];
    _currentParties = [[query findObjects] mutableCopy];

     //Initialize pull-to-refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor grayColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(refreshData)
                  forControlEvents:UIControlEventValueChanged];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _currentParties.count;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdent = @"tavoloCell";
    TavoloTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdent forIndexPath:indexPath];
    long row = [indexPath row];
    
    PFObject *currentObject = [_currentParties objectAtIndex:row];
    
    PFQuery *userQuery = [PFUser query];
    PFUser *user = ((PFUser *)[userQuery getObjectWithId:[[currentObject objectForKey:@"user"] objectId]]);
    
    cell.nameLabel.text = [user objectForKey:@"additional"];
    cell.subLabel.text = [NSString stringWithFormat:@"%@ people", [currentObject objectForKey:@"partySize"]];
    cell.waitLabel.text = [NSString stringWithFormat:@"%.0f min", (-[[currentObject updatedAt] timeIntervalSinceNow] / 60.0)];
    
    return cell;
}

- (void)refreshData {
    PFQuery *query =[PFQuery queryWithClassName:@"newQueue"];
    [query whereKey:@"restaurant" equalTo:[PFUser currentUser].objectId];
    [query orderByAscending:@"partySize"];
    _currentParties = [[query findObjects] mutableCopy];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
 
        PFObject *obj = [_currentParties objectAtIndex:indexPath.row];
        NSString *table = [NSString stringWithFormat:@"tables%@",[[_currentParties objectAtIndex:indexPath.row] objectForKey:@"partySize"]];
        NSString *counter = [NSString stringWithFormat:@"counter%@",[[_currentParties objectAtIndex:indexPath.row] objectForKey:@"partySize"]];
        NSString *people = [NSString stringWithFormat:@"people%@",[[_currentParties objectAtIndex:indexPath.row] objectForKey:@"partySize"]];
        PFQuery *settings = [PFQuery queryWithClassName:@"RestaurantSettings"];
        [settings whereKey:@"restaurant" equalTo:[PFUser currentUser].objectId];
        [settings getFirstObjectInBackgroundWithBlock:^(PFObject *chairs, NSError *error) {
            if ([[chairs objectForKey:table]integerValue ] > 0)
            {
                
                chairs[table] = @([[chairs objectForKey:table] integerValue]-1);
                [chairs saveInBackground];
                PFQuery *q = [PFQuery queryWithClassName:@"Stats"];
                [q whereKey:@"restaurant" equalTo:[PFUser currentUser].objectId];
                [q getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error)
                {
                    NSInteger mins = [[object objectForKey:people] integerValue]; //Look at Mins column
                    NSInteger count = [[object objectForKey:counter] integerValue]; //Look at people column
                    NSInteger waitval = mins/count; //Create avg expected wait time
                    PFObject *seatQueue = [PFObject objectWithClassName:@"Seated"];
                    seatQueue[@"restaurant"] = [obj objectForKey:@"restaurant"];
                    seatQueue[@"user"] = [obj objectForKey:@"user"];
                    seatQueue[@"Size"] = [obj objectForKey:@"partySize"];
                    mins = [[object objectForKey:people] integerValue]; //Look at Mins column
                    count = [[object objectForKey:counter] integerValue]; //Look at people column
                    waitval = mins/count;
                    NSDate *end = [[NSDate date] dateByAddingTimeInterval:waitval*60]; //add to the time now
                    seatQueue[@"EndTime"] = end;
                    [seatQueue saveInBackground];
                    [[_currentParties objectAtIndex:indexPath.row] deleteInBackground];
                    [_currentParties removeObjectAtIndex:indexPath.row];
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
               
                 }];
            }
        }];
    }
}

/*- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [sectionTitles objectAtIndex:section];
}*/
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
