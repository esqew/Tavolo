//
//  WaitScreenViewController.m
//  Tavolo
//
//  Created by MAC on 4/13/15.
//  Copyright (c) 2015 Tavolo Team. All rights reserved.
//

#import "WaitScreenViewController.h"
#import <Parse/Parse.h>
@interface WaitScreenViewController ()

@end

@implementation WaitScreenViewController {
    UIImage *downImage, *upImage;
    UIBarButtonItem *specialsButton;
    Boolean specialsShowing;
    NSInteger mins;
    NSTimer *timer;
}

- (BOOL)shouldAutorotate {
    return NO;
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
    
    _dropDown = [[DropDownViewController alloc] initWithArrayData:_arrayData cellHeight:30 heightTableView:200 paddingTop:-8 paddingLeft:-5 paddingRight:-10 refView:_toolbar animation:BLENDIN openAnimationDuration:1 closeAnimationDuration:1];
    
    [self.view addSubview:_dropDown.view];
    
    specialsShowing = NO;
    
    //Wait Time
    PFQuery *query = [PFQuery queryWithClassName:@"newQueue"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *waitObj, NSError *er)
     {
         if(waitObj.count == 0)
         {
             _waitTimeLabel.text = @"0";
         }
         else
         {
             PFObject *obj = [waitObj objectAtIndex:0];

             NSDate *start = [obj createdAt];
             NSDate *end = [obj objectForKey:@"seatTime"];
             NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
             [dateFormatter setDateFormat:@"hh:mm a"];
             NSString *stringFromDate = [dateFormatter stringFromDate:[obj objectForKey:@"createdAt"]];
             NSString *stringFromDate2 = [dateFormatter stringFromDate:[obj objectForKey:@"seatTime"]];
             NSLog(@"Date 1: %@ ... Date 2: %@", stringFromDate, stringFromDate2);
              NSTimeInterval distanceBetweenDates = [end timeIntervalSinceDate:start];
             double secondsInAMin = 60;
             mins = distanceBetweenDates / secondsInAMin;
             NSLog(@"Minutes %lu", mins);
             NSString *minutes = [NSString stringWithFormat:@"%lu", mins];
             _waitTimeLabel.text = minutes;
             
             //Start timer to update waiting time every minute
             timer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(updateWaitTime) userInfo:nil repeats:YES];
         }
     }];
}

//Fired by timer to update wait time label every minute
- (void)updateWaitTime {
    if(mins == 0)
    {
        [timer invalidate];
    }
    else
    {
        mins--;
        NSString *waitTime = [NSString stringWithFormat:@"%lu",mins];
        _waitTimeLabel.text = waitTime;
    }
}

- (void)setUpView:(PFObject *)object {
    
}

- (IBAction)leaveQueue:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"Queue"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query whereKeyExists:@"venue"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [((PFObject *)[objects objectAtIndex:0]) deleteInBackground];
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (IBAction)callPhone:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://6103372200"]];
}

- (void)drawCircle {
    // Set up the shape of the circle
    int radius = 90;
    CAShapeLayer *circle = [CAShapeLayer layer];
    // Make a circular shape
    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
                                             cornerRadius:radius].CGPath;
    // Center the shape in self.view
    circle.position = CGPointMake(CGRectGetMidX(self.waitTimeLabel.frame)-radius - 128,
                                  CGRectGetMidY(self.waitTimeLabel.frame)-radius - 133);
    
    // Configure the apperence of the circle
    circle.fillColor = [UIColor lightGrayColor].CGColor;
    circle.opacity = 0.4f;
    //circle.strokeColor = [UIColor blackColor].CGColor;
    //circle.lineWidth = 5;
    
    // Add to parent layer
    [self.waitTimeLabel.layer addSublayer:circle];
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
