//
//  WaitScreenViewController.m
//  Tavolo
//
//  Created by MAC on 4/13/15.
//  Copyright (c) 2015 Tavolo Team. All rights reserved.
//

#import "WaitScreenViewController.h"

@interface WaitScreenViewController ()

@end

@implementation WaitScreenViewController {
    UIImage *downImage, *upImage;
    UIBarButtonItem *specialsButton;
    Boolean specialsShowing;
}

- (void)viewDidLoad {
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    [self drawCircle];
    
    //Set up toolbar
    downImage = [UIImage imageNamed:@"Down4-50.png"];
    upImage = [UIImage imageNamed:@"Up4-50.png"];
    specialsButton = [[UIBarButtonItem alloc] initWithImage:downImage style:UIBarButtonItemStylePlain target:self action:@selector(dropMenu)];
    /*UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];*/
    [_toolbar setItems:[NSArray arrayWithObjects:specialsButton, nil]];
    
    //Set up Drop Down View
    _arrayData = @[@"Pizza        $12.99", @"Steak        $17.99", @"Cheesecake        $9.99"];
    
    _dropDown = [[DropDownViewController alloc] initWithArrayData:_arrayData cellHeight:30 heightTableView:200 paddingTop:-8 paddingLeft:-5 paddingRight:-10 refView:_toolbar animation:BLENDIN openAnimationDuration:2 closeAnimationDuration:2];
    
    [self.view addSubview:_dropDown.view];
    
    specialsShowing = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dropMenu {
    if(specialsShowing)
    {
        [_dropDown closeAnimation];
        specialsShowing = NO;
        [specialsButton setImage:downImage];
        
    }
    else
    {
        [_dropDown openAnimation];
        specialsShowing = YES;
        [specialsButton setImage:upImage];
    }
}

- (void)drawCircle {
    // Set up the shape of the circle
    int radius = 90;
    CAShapeLayer *circle = [CAShapeLayer layer];
    // Make a circular shape
    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
                                             cornerRadius:radius].CGPath;
    // Center the shape in self.view
    circle.position = CGPointMake(CGRectGetMidX(self.view.frame)-radius,
                                  CGRectGetMidY(self.view.frame)-radius -120);
    
    // Configure the apperence of the circle
    circle.fillColor = [UIColor lightGrayColor].CGColor;
    circle.opacity = 0.4f;
    //circle.strokeColor = [UIColor blackColor].CGColor;
    //circle.lineWidth = 5;
    
    // Add to parent layer
    [self.view.layer addSublayer:circle];
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
