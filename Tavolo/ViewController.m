//
//  ViewController.m
//  Tavolo
//
//  Created by Sean on 1/31/15.
//  Copyright (c) 2015 Tavolo Team. All rights reserved.
//

#import "ViewController.h"
#import "TavoloLoginViewController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - Methods

- (IBAction)logOut:(id)sender {
    // provide a method to log out from the ib ui
    [[PFInstallation currentInstallation] setObject:nil forKey:@"user"];
    [[PFInstallation currentInstallation] saveEventually];
    [PFPush unsubscribeFromChannelInBackground:[[PFUser currentUser] objectForKey:@"type"]];
    [PFUser logOut];
    if (![PFUser currentUser]) {
        TavoloLoginViewController *loginViewController = [[TavoloLoginViewController alloc] init];
        [self presentViewController:loginViewController animated:YES completion:nil];
    }
}

#pragma mark - Class method implementations

- (NSUInteger)supportedInterfaceOrientations {
    // support all user interfaces to the best of our ability, as per Apple Human Interface Guidelines
    return UIInterfaceOrientationMaskAll;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // hack to ensure status bar stays visible when transitioning to landscape
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    pinLabel.layer.cornerRadius = 5.0f;
    pinLabel.clipsToBounds = YES;
    
    pinLabel.alpha = 0.0f;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // if there's no user in the local parse cache, prompt the user to log in
    if (![PFUser currentUser]) {
        TavoloLoginViewController *loginViewController = [[TavoloLoginViewController alloc] init];
        [self presentViewController:loginViewController animated:YES completion:nil];
    } else {
        // there's a user logged in, hooray!
        PFQuery *query = [PFQuery queryWithClassName:@"Queue"];
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
        [query whereKeyExists:@"venue"];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            PFQuery *restaurantQuery = [PFUser query];
            [restaurantQuery whereKey:@"objectId" equalTo:[[[objects objectAtIndex:0] objectForKey:@"venue"] objectId]];
            [restaurantQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                [self performSegueWithIdentifier:@"waitScreenSegue" sender:nil];
            }];
        }];
        
        // if this is a restaurant account, move them directly to the hostess view
        [[PFUser currentUser] fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if ([[object objectForKey:@"type"] isEqualToString:@"restaurant"]) {
                [self performSegueWithIdentifier:@"restaurantSegue" sender:nil];
            } else {
                // if user isn't a restaurant account, get a PIN for the user
                [PFCloud callFunctionInBackground:@"generatePIN" withParameters:@{} block:^(id object, NSError *error) {
                    pinLabel.text = [NSString stringWithFormat:@"%@", object];
                    [UIView animateWithDuration:0.5 animations:^{
                        pinLabel.alpha = 1.0f;
                    }];
                    checker = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(checkForUpdate:) userInfo:self repeats:YES];
                }];
            }
        }];
    }
}

- (void)checkForUpdate:(id)sender {
    if (![PFUser currentUser]) [checker invalidate];
    else {
        PFQuery *query = [PFQuery queryWithClassName:@"Queue"];
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
        [query whereKeyExists:@"venue"];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            PFQuery *restaurantQuery = [PFUser query];
            [restaurantQuery whereKey:@"objectId" equalTo:[[[objects objectAtIndex:0] objectForKey:@"venue"] objectId]];
            [restaurantQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                PFUser *restaurant = [objects objectAtIndex:0];
                [self performSegueWithIdentifier:@"waitScreenSegue" sender:nil];
                [checker invalidate];
            }];
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
