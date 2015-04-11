//
//  RestaurantCell.h
//  Tavolo
//
//  Created by Alex Wright on 4/11/15.
//  Copyright (c) 2015 Tavolo Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestaurantCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *TabNumLab;
@property (weak, nonatomic) IBOutlet UILabel *PartyLab;
@property (weak, nonatomic) IBOutlet UILabel *SeatedLab;
@property (weak, nonatomic) IBOutlet UILabel *WaitLab;

@end
