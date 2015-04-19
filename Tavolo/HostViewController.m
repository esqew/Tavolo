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

- (IBAction)addToQueue:(id)sender {
    PFQuery *addQuery = [PFQuery queryWithClassName:@"Queue"];
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
    }];
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
