//
//  SettingsViewController.m
//  Tavolo
//
//  Created by Alex Wright on 4/5/15.
//  Copyright (c) 2015 Tavolo Team. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        // Do any additional setup after loading the view.
}
- (IBAction)saveClick:(id)sender {
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
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
