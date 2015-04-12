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

@interface RestaurantTableController ()

@end

@implementation RestaurantTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    Customer *cust1 = [[Customer alloc] initWithGuestName:@"Niko" partySize:@"2" tableNum:@"-1"  waitTime:@"10" seated:NO];
    
        Customer *cust2 = [[Customer alloc] initWithGuestName:@"Alex" partySize:@"2" tableNum:@"-1"  waitTime:@"9" seated:NO];
    
    _currentParties = [[NSMutableArray alloc] init];
    [_currentParties addObject:cust1];
    [_currentParties addObject:cust2];

     //Initialize pull-to-refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor grayColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(getDownloadedResources)
                  forControlEvents:UIControlEventValueChanged];
    UILabel * title  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 45)];
    title.text = @"Name \t Table# \t Size \t Seated \t Wait";
    self.tableView.tableHeaderView = title;
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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return _currentParties.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdent = @"customCell";
    RestaurantCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdent forIndexPath:indexPath];
    long row = [indexPath row];
    
    Customer *tempcust = _currentParties[row];
    cell.nameLab.text = tempcust.guestName;
    cell.PartyLab.text =  tempcust.partySize;
    cell.TabNumLab.text =  tempcust.table;
    cell.WaitLab.text = tempcust.waitTime;
    if (tempcust.seated) {
        cell.SeatedLab.text = @"Yes";
    }
    else
    {
        cell.SeatedLab.text = @"No";
    }
    // Configure the cell...
    
    return cell;
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
