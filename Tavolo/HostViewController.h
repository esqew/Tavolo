//
//  HostViewController.h
//  Tavolo
//
//  Created by Alex Wright on 3/28/15.
//  Copyright (c) 2015 Tavolo Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HostViewController : UIViewController <UITextFieldDelegate> {
    IBOutlet UITextField *pinField;
    IBOutlet UITextField *nameField;
}
@end
