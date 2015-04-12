//
//  TavoloSignupViewController.m
//  Tavolo
//
//  Created by Sean on 2/20/15.
//  Copyright (c) 2015 Tavolo Team. All rights reserved.
//

#import <Parse/Parse.h>
#import "TavoloSignupViewController.h"
#import "UIColor+TavoloColor.h"
#import "TavoloLabel.h"

@interface TavoloSignupViewController ()

@end

@implementation TavoloSignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // h/t to https://www.parse.com/tutorials/login-and-signup-views
    
    self.delegate = self;
    
    [self.signUpView setBackgroundColor:[UIColor tavoloColor]];
    
    [self.signUpView setEmailAsUsername:YES];
    [self.signUpView.additionalField setPlaceholder:@"Full name"];
    [self.signUpView.additionalField setSeparatorStyle:PFTextFieldSeparatorStyleTop|PFTextFieldSeparatorStyleBottom];
    
    TavoloLabel *titleLabel = [[TavoloLabel alloc] init];
    [titleLabel setText:@"TAVOLO Signup"];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont fontWithName:@"Roboto-Thin" size:40.0]];
    
    [self.signUpView setLogo:titleLabel];
    [self.signUpView.logo awakeFromNib];
    
    [self.signUpView.dismissButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [user setObject:@"user" forKey:@"type"];
    [user save];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.signUpView.emailField becomeFirstResponder];
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
