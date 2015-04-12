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

 
    // Do any additional setup after loading the view.
    
    pinField.delegate = self;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField == pinField) {
        // find name of user with a specific pin assigned to them
        PFQuery *pinQuery = [PFUser query];
        [pinQuery whereKey:@"pin" equalTo:[NSNumber numberWithInt:[pinField.text intValue]]];
        [pinQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (objects.count != 1) {
                
            } else {
                nameField.text = ((NSString *)[((PFUser *)[objects objectAtIndex:0]) objectForKey:@"additional"]);
            }
        }];
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
