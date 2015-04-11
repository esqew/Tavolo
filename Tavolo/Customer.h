//
//  Customer.h
//  WaitQueue
//
//  Created by Alex Wright on 3/12/15.
//  Copyright (c) 2015 Alex Wright. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Customer : NSObject
@property NSString *guestName;
@property NSString * partySize;
@property NSString * table;
@property NSString * waitTime;
@property BOOL * seated;
- (id)initWithGuestName:(NSString *)name partySize:(NSString *)size tableNum:(NSString *)table waitTime:(NSString *)time seated:(BOOL)isSeated;
@end
