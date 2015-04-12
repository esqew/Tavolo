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

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - Methods

- (IBAction)logOut:(id)sender {
    // provide a method to log out from the ib ui
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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // if there's no user in the local parse cache, prompt the user to log in
    if (![PFUser currentUser]) {
        TavoloLoginViewController *loginViewController = [[TavoloLoginViewController alloc] init];
        [self presentViewController:loginViewController animated:YES completion:nil];
    } else {
        // if this is a restaurant account, move them directly to the hostess view
        [[PFUser currentUser] fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if ([[object objectForKey:@"type"] isEqualToString:@"restaurant"]) {
                [self performSegueWithIdentifier:@"restaurantView" sender:nil];
            }
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
