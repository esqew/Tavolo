//
//  TavoloTableViewCell.m
//  Tavolo
//
//  Created by Sean on 4/15/15.
//  Copyright (c) 2015 Tavolo Team. All rights reserved.
//

#import "TavoloTableViewCell.h"

@implementation TavoloTableViewCell
@synthesize nameLabel, subLabel, waitLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
