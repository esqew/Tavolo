//
//  Customer.m
//  WaitQueue
//
//  Created by Alex Wright on 3/12/15.
//  Copyright (c) 2015 Alex Wright. All rights reserved.
//

#import "Customer.h"

@implementation Customer:NSObject


- (id)initWithGuestName:(NSString *)name partySize:(NSString *)size tableNum:(NSString *)table waitTime:(NSString *)time seated:(BOOL)isSeated {
    self = [[Customer alloc] init];

    if (self) {
        _guestName = name;
        _partySize = size;
        _table = table;
        _waitTime = time;
        _seated = &isSeated;
    }
    
    
    
    return self;
}

@end
