//
//  ViewController.h
//  Tavolo
//
//  Created by Sean on 1/31/15.
//  Copyright (c) 2015 Tavolo Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    IBOutlet UILabel *pinLabel;
    NSTimer *checker;
}

- (IBAction)logOut:(id)sender;

@end

