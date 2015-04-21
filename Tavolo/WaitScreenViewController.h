//
//  WaitScreenViewController.h
//  Tavolo
//
//  Created by MAC on 4/13/15.
//  Copyright (c) 2015 Tavolo Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "DropDownViewController.h"

@interface WaitScreenViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *waitTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *returnTimeLabel;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UIImageView *restaurantImage;
@property (strong, nonatomic) NSArray *arrayData;
@property (strong, nonatomic) DropDownViewController *dropDown;

- (IBAction)callPhone:(id)sender;
- (IBAction)leaveQueue:(id)sender;
- (void)drawCircle;
- (void)setUpView:(PFObject *)object;

@end
