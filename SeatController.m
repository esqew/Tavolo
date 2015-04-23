//
//  SeatController.m
//  Tavolo
//
//  Created by Alex Wright on 4/22/15.
//  Copyright (c) 2015 Tavolo Team. All rights reserved.
//

#import "SeatController.h"
#import "SeatCell.h"
#import <Parse/Parse.h>
@interface SeatController ()

@end

@implementation SeatController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _seatedParties = [[NSMutableArray alloc] init];
    PFQuery *query =[PFQuery queryWithClassName:@"Seated"];
    [query whereKey:@"restaurant" equalTo:[PFUser currentUser].objectId];
    [query orderByAscending:@"Size"];
    _seatedParties = [[query findObjects] mutableCopy];

    
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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return _seatedParties.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdent = @"seater";
    SeatCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdent forIndexPath:indexPath];
    long row = [indexPath row];
    
    
    PFObject *currentObject = [_seatedParties objectAtIndex:row];
    
    PFQuery *userQuery = [PFUser query];
    PFUser *user = ((PFUser *)[userQuery getObjectWithId:[[currentObject objectForKey:@"user"] objectId]]);
    
    cell.name.text = [user objectForKey:@"additional"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *stringFromDate = [dateFormatter stringFromDate:[currentObject objectForKey:@"EndTime"]];
    cell.endtime.text = [NSString stringWithFormat:@"%@", stringFromDate];//(-[[currentObject updatedAt] timeIntervalSinceNow] / 60.0)];
    
    return cell;
}

- (void)refreshData {
    PFQuery *query =[PFQuery queryWithClassName:@"Seated"];
    [query whereKey:@"restaurant" equalTo:[PFUser currentUser]];
    [query orderByAscending:@"Size"];
    _seatedParties = [[query findObjects] mutableCopy];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_seatedParties removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];   }
}


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
