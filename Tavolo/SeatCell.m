//
//  SeatCell.m
//  Tavolo
//
//  Created by Alex Wright on 4/22/15.
//  Copyright (c) 2015 Tavolo Team. All rights reserved.
//

#import "SeatCell.h"

@implementation SeatCell
@synthesize name,endtime;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
