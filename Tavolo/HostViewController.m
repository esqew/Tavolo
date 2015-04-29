//
//  HostViewController.m
//  Tavolo
//
//  Created by Alex Wright on 3/28/15.
//  Copyright (c) 2015 Tavolo Team. All rights reserved.
//

#import <Parse/Parse.h>
#import "HostViewController.h"

@interface HostViewController ()

@end

@implementation HostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[[PFUser currentUser] objectForKey:@"type"] isEqualToString:@"user"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
 
    // Do any additional setup after loading the view.
    
    pinField.delegate = self;
    pinField.keyboardType = UIKeyboardTypeNumberPad;
}

- (IBAction)logOut:(id)sender {
    [[PFInstallation currentInstallation] setObject:nil forKey:@"user"];
    [PFPush unsubscribeFromChannelInBackground:[[PFUser currentUser] objectForKey:@"type"]];
    [PFUser logOut];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addToQueue:(id)sender {
    
    /* These Strings are used to build the appropriate column references for the DB Columns I.E tables2 counter3 etc*/
    NSString *tables = @"tables";
    NSString *counter = @"counter";
    NSString *people = @"people";
    NSDate *today = [NSDate date];
    
    
    PFQuery * check = [PFQuery queryWithClassName:@"RestaurantSettings"]; //Start a query for Settings to see if the party size is a non zero value
    
    if ([sizeField.text integerValue] > 5) { //normalize all party entries larger than 5 to 5
        sizeField.text = @"5";
        
    }
    //Build the appropriate string dependent on party size to reference columns correctly in Stats Table
    tables = [tables stringByAppendingString:sizeField.text];
    counter = [counter stringByAppendingString:sizeField.text];
    people = [people stringByAppendingString:sizeField.text];
    NSNumber *num = [NSNumber numberWithInteger:[sizeField.text integerValue]];
    NSNumber *pinNum = [NSNumber numberWithInteger:[pinField.text integerValue]];

    /* Check Query : so using restaurant objectid and table size find how many available tables*/
    [check whereKey:@"restaurant" equalTo:[PFUser currentUser].objectId];
    [check getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        NSLog(@"Number returned of available seats %@",[object objectForKey:tables]);
        if ([[object objectForKey:tables] integerValue] > 0) //Is the value returned greateer than zero if so We seat Customer
        {
            NSLog(@"Seating Customer");
            NSNumber *seats = [object objectForKey:tables];
            NSNumber *chairs = @([seats integerValue] - 1);
            NSLog(@"SeatsBefore%@", seats);


            object[tables] = chairs;
            
            [object saveInBackground];
            /*******************************************************
             ****************************************************
             NEED TO DECREMENT Table Counter For Restaurant HERE
             NOT COOPERATING
             **********************************************/
            
            //Query to Build End Time
            //So we have to find out when we expect Customer to finish eating by querying Stats
            PFQuery * time = [PFQuery queryWithClassName:@"Stats"];
            [time whereKey:@"restaurant" equalTo:[PFUser currentUser].objectId]; //So get record for Restaurant based on Id of the logged in Restaurant
            [time getFirstObjectInBackgroundWithBlock:^(PFObject *objects, NSError *error)
             {
                 NSInteger mins = [[objects objectForKey:people] integerValue]; //Look at Mins column
                 NSInteger count = [[objects objectForKey:counter] integerValue]; //Look at people column
                 NSInteger waitval = mins/count; //Create avg expected wait time
                 NSDate *end = [today dateByAddingTimeInterval:waitval*60]; //add to the time now
                 PFQuery *pin = [PFQuery queryWithClassName:@"Queue"];
                 [pin whereKey:@"pin" equalTo:pinNum];
                 [pin getFirstObjectInBackgroundWithBlock:^(PFObject *obj, NSError *er)
                  {
                      PFObject * seat = [PFObject objectWithClassName:@"Seated"];
                      seat[@"EndTime"] = end;
                      seat[@"user"] = [obj objectForKey:@"user"];
                      seat[@"restaurant"] = [PFUser currentUser].objectId;//This is incorrect not sure how to get user associated with pin
                      seat[@"Size"] = num;
                      [seat saveInBackground];
                  }];
                 
                 //Create a record to put in Seated Table with when expected to finish eating

             }];
            
        }
        else //If there are no available seats we must add them to Queue
        {
            /*PFQuery *addQuery = [PFQuery queryWithClassName:@"Queue"];
             NSNumber *number = [NSNumber numberWithInteger:[pinField.text integerValue]];
             [addQuery whereKey:@"pin" equalTo:number];
             [addQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
             if (objects.count != 1);
             else {
             PFObject *object = [objects objectAtIndex:0];
             [object setObject:[PFUser currentUser] forKey:@"venue"];
             [object setObject:[NSNumber numberWithInteger:0] forKey:@"seated"];
             [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
             }];
             }
             }];*/
            
            
            NSNumber *s = [NSNumber numberWithInteger: [sizeField.text intValue]]; //Creates number for Party size... It was necessary for Data type purposes
            
            //Start a query on the Queue to find how many people are waiting
            PFQuery * wait = [PFQuery queryWithClassName:@"newQueue"];
            [wait whereKey:@"restaurant" equalTo:[PFUser currentUser].objectId]; //based on Restaurant ID
            [wait whereKey:@"partySize" equalTo:s]; // Based on Party Size
            [wait findObjectsInBackgroundWithBlock:^(NSArray *waitObj, NSError *er)
             {
                 NSLog(@"%lu, %@", (unsigned long)waitObj.count, s);
                 //Now we have objects that are restricted to a party size and Restaurant
                 //Now need to find the expected time to finish for seated Customer
                 /*To Explain if customer is the 3rd person in line waited to be seated then the corresponding wait time would be the 3rd person closest to finish eating. So this query finds all of the people eating at a restaurant with a specific party size and orders them by when they were added to the Seat queue since they would finish first*/
                 PFQuery *addqueue = [PFQuery queryWithClassName:@"Seated"];
                 [addqueue whereKey:@"restaurant" equalTo:[PFUser currentUser].objectId];
                 [addqueue whereKey:@"Size" equalTo:s];
                 [addqueue orderByAscending:@"createdAt"];
                 [addqueue findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
                  {
                     if (!error)
                     {
                         NSLog(@"OBJECTS%lu and %lu", objects.count, waitObj.count);
                         if(waitObj.count >= objects.count)
                         {
                             NSDate *next = [[objects objectAtIndex:objects.count-1] objectForKey:@"EndTime"];
                             NSLog(@"%@", next);
                             long counter2 = waitObj.count - objects.count+1;
                             PFQuery * time2 = [PFQuery queryWithClassName:@"Stats"];
                             [time2 whereKey:@"restaurant" equalTo:[PFUser currentUser].objectId]; //So get record for Restaurant based on Id of the logged in Restaurant
                             [time2 getFirstObjectInBackgroundWithBlock:^(PFObject *objects, NSError *error)
                              {
                                  NSInteger mins2 = [[objects objectForKey:people] integerValue]; //Look at Mins column
                                  NSInteger count2 = [[objects objectForKey:counter] integerValue]; //Look at people column
                                  NSInteger waitval2 = mins2/count2; //Create avg expected wait time
                                  NSDate *end2 = [next dateByAddingTimeInterval:waitval2*60*counter2]; //add to the time now
                                  NSLog(@"Begin : %@...End : %@", next, end2);

                                  PFQuery *name = [PFQuery queryWithClassName:@"Queue"];
                                  [name whereKey:@"pin" equalTo:pinNum];
                                  [name getFirstObjectInBackgroundWithBlock:^(PFObject *person, NSError *error)
                                  {
                                      PFObject *eat = [PFObject objectWithClassName:@"newQueue"];
                                      eat[@"restaurant"]=[PFUser currentUser].objectId;
                                      eat[@"seatTime"] = end2;
                                      eat[@"partySize"] = s;
                                      eat[@"user"] = [person objectForKey:@"user"];
                                      [eat saveInBackground];
                                  }];

                              }];
                             
                             
                         }
                         else
                         {
                             NSLog(@"HERE");
                             PFQuery *addname = [PFQuery queryWithClassName:@"Queue"];
                             [addname whereKey:@"pin" equalTo:pinNum];
                             [addname getFirstObjectInBackgroundWithBlock:^(PFObject *persons, NSError *error){
                              //Creates an object to be added to the queue
                              PFObject *waiter = [PFObject objectWithClassName:@"newQueue"];
                              waiter[@"restaurant"] = [PFUser currentUser].objectId; //links user to restuarant
                              PFObject * temp = [objects objectAtIndex:waitObj.count]; //Finds corresponding EndTime for when they can expect to sit down and eat
                              waiter[@"seatTime"] = [temp objectForKey:@"EndTime"];
                              waiter[@"partySize"] = s;
                                 waiter[@"user"] = [persons objectForKey:@"user"];
                              [waiter saveInBackground]; //adds to queue
                             }];
                         }
                     } else {
                         // Log details of the failure
                         NSLog(@"Error: %@ %@", error, [error userInfo]);
                     }
                 }];
                 
                 
             }];
            
        }
    }];

/*
    PFQuery *addQuery = [PFQuery queryWithClassName:@"Queue"];
    NSNumber *number = [NSNumber numberWithInteger:[pinField.text integerValue]];
    [addQuery whereKey:@"pin" equalTo:number];
    [addQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count != 1);
        else {
            PFObject *object = [objects objectAtIndex:0];
            [object setObject:[PFUser currentUser] forKey:@"venue"];
            [object setObject:[NSNumber numberWithInt:[sizeField.text intValue]] forKey:@"size"];
            [object setObject:[NSNumber numberWithInteger:0] forKey:@"seated"];
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            }];
        }
    }];*/
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField == pinField) {
        nameField.userInteractionEnabled = NO;
        // find name of user with a specific pin assigned to them
        PFQuery *pinQuery = [PFQuery queryWithClassName:@"Queue"];
        [pinQuery whereKey:@"pin" equalTo:[NSNumber numberWithInt:[pinField.text intValue]]];
        [pinQuery includeKey:@"additional"];
        [pinQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (objects.count != 1) {
                
            } else {
                //nameField.text = ((NSString *)[((PFUser *)[objects objectAtIndex:0]) objectForKey:@"additional"]);
                PFQuery *query = [PFUser query];
                [query getObjectInBackgroundWithId:[[[objects objectAtIndex:0] objectForKey:@"user"] objectId] block:^(PFObject *object, NSError *error) {
                    nameField.text = [object objectForKey:@"additional"];
                }];
            }
        }];
        nameField.userInteractionEnabled = YES;
    }
    
    return YES;

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
@end
