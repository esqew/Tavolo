//
//  TavoloLoginViewController.m
//  Tavolo
//
//  Created by Sean on 2/5/15.
//  Copyright (c) 2015 Tavolo Team. All rights reserved.
//

// TODO: Implement Reachability.h

#import <Parse/Parse.h>
#import "TavoloLoginViewController.h"
#import "UIColor+TavoloColor.h"
#import "TavoloLabel.h"

@interface TavoloLoginViewController ()

@end

@implementation TavoloLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    // Do any additional setup after loading the view.
    // h/t to https://www.parse.com/tutorials/login-and-signup-views
    
    [self.logInView setBackgroundColor:[UIColor tavoloColor]];
    self.emailAsUsername = YES;
    
    // replace the logo with our own custom label
    TavoloLabel *titleLabel = [[TavoloLabel alloc] init];
    [titleLabel setText:@"TAVOLO.IO"];
    [titleLabel setTextColor:[UIColor whiteColor]];
        
    // re-declare font (even though it's specified in the subclass) in order to ensure the correct font size
    [titleLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:40.0]];
    [self.logInView setLogo:titleLabel];
    [self.logInView.logo awakeFromNib];
    [self.logInView dismissButton].hidden = YES;
    
    // change the appearance of the login button
    [self.logInView.logInButton setBackgroundImage:nil forState:UIControlStateNormal];
    [self.logInView.logInButton setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5]];

    [self.logInView.signUpButton setBackgroundImage:nil forState:UIControlStateNormal];
    [self.logInView.signUpButton setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0]];
    
    [self.logInView.usernameField becomeFirstResponder];
}

#pragma mark - PFLogInViewControllerDelegate Protocol Implementation

- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // perform custom validation here, return YES if the login should continue
    BOOL valid = username && password && username.length > 0 && password.length > 0;
    if (!valid) {
        // alert that the user's input hasn't passed validation rules
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Missing information" message:@"Please fill out both the username and password fields." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
            [self.logInView.usernameField becomeFirstResponder];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    return valid;
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    // we should never hit this method because the app shouldn't be usable without an account
}

- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    // display an alert and clear the password entry
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Incorrect login" message:@"The username or password provided was invalid." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismiss = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
        [self.logInView.usernameField becomeFirstResponder];
    }];
    [alert addAction:dismiss];
    [self presentViewController:alert animated:YES completion:nil];
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
