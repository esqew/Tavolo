//
//  SettingsViewController.m
//  Tavolo
//
//  Created by Alex Wright on 4/5/15.
//  Copyright (c) 2015 Tavolo Team. All rights reserved.
//

#import "SettingsViewController.h"
#import <Parse/Parse.h>

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        // Do any additional setup after loading the view.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (IBAction)saveClick:(id)sender {
    NSNumber *two = @([_twoTable.text integerValue]);
    NSNumber *three = @([_threeTable.text integerValue]);
    NSNumber *four = @([_fourTable.text integerValue]);
    NSNumber *five = @([_fiveTable.text integerValue]);

    PFQuery *q = [PFQuery queryWithClassName:@"RestaurantSettings"];
    [q whereKey:@"restaurant" equalTo:[PFUser currentUser].objectId];
    [q findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            if(objects.count == 0)
            {
                PFObject *addSettings = [PFObject objectWithClassName:@"RestaurantSettings"];
                addSettings[@"restaurant"] = [PFUser currentUser].objectId;
                addSettings[@"tables2"] = two;
                addSettings[@"tables3"] = three;
                addSettings[@"tables4"] = four;
                addSettings[@"tables5"] = five;
                [addSettings saveInBackground];

            }
            else
            {
                NSLog(@"Record Exists");
                PFObject *obj = [objects objectAtIndex:0];
                obj[@"tables2"] = two;
                obj[@"tables3"] = three;
                obj[@"tables4"] = four;
                obj[@"tables5"] = five;
                [obj saveInBackground];
            }
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
   
    
    /*NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dirName = [docDir stringByAppendingPathComponent:@"settings"];
    
    BOOL isDir;
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:dirName isDirectory:&isDir])
    {
        if([fm createDirectoryAtPath:dirName withIntermediateDirectories:YES attributes:nil error:nil])
            NSLog(@"Directory Created");
        else
            NSLog(@"Directory Creation Failed");
    }
    else
        NSLog(@"Directory Already Exist");
    
    NSFileManager *manager;
    manager = [NSFileManager defaultManager];
    NSString * file = @"seating.txt";
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fileloc = [documentsDirectory stringByAppendingPathComponent: file];
    NSLog(@"full path name: %@", fileloc);
    
    // check if file exists
    if ([manager fileExistsAtPath: fileloc] == YES){
        NSLog(@"File exists");
        NSError *error = nil;

        NSString *data = [NSString stringWithFormat:@"%@,%@,%@,%@",_twoTable.text,_threeTable.text,_fourTable.text,_fiveTable.text];
        NSLog(@"%@", data);
        [data writeToFile:fileloc atomically:YES encoding:NSStringEncodingConversionAllowLossy error:&error];
        NSString *content = [NSString stringWithContentsOfFile:fileloc encoding:NSStringEncodingConversionAllowLossy error:&error];
        NSLog(@"File Content: %@", content);
        NSLog(@"Here");
        
        
        
    }else {
        NSLog (@"File not found, file will be created");
        if (![manager createFileAtPath:fileloc contents:nil attributes:nil]){
            NSLog(@"Create file returned NO");
        }
    }
*/
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
