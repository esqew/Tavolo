//
//  SeatCell.h
//  Tavolo
//
//  Created by Alex Wright on 4/22/15.
//  Copyright (c) 2015 Tavolo Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeatCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *endtime;

@end
