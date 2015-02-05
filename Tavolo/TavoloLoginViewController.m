//
//  TavoloLoginViewController.m
//  Tavolo
//
//  Created by Sean on 2/5/15.
//  Copyright (c) 2015 Tavolo Team. All rights reserved.
//

#import "TavoloLoginViewController.h"
#import "UIColor+TavoloColor.h"
#import "TavoloLabel.h"

@interface TavoloLoginViewController ()

@end

@implementation TavoloLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
