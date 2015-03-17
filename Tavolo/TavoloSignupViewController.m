//
//  TavoloSignupViewController.m
//  Tavolo
//
//  Created by Sean on 2/20/15.
//  Copyright (c) 2015 Tavolo Team. All rights reserved.
//

#import "TavoloSignupViewController.h"

@interface TavoloSignupViewController ()

@end

@implementation TavoloSignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // h/t to https://www.parse.com/tutorials/login-and-signup-views
    self.delegate = self;
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
