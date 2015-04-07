//
//  TavoloLabel.m
//  Tavolo
//
//  Created by Sean on 2/2/15.
//  Copyright (c) 2015 Tavolo Team. All rights reserved.
//

#import "TavoloLabel.h"

@implementation TavoloLabel

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([self.text isEqualToString:@"TAVOLO.IO"]) {
        UIFont *medium = [UIFont fontWithName:@"Roboto-Medium" size:self.font.pointSize];
        NSDictionary *mediumDict = [NSDictionary dictionaryWithObject:medium forKey:NSFontAttributeName];
        NSMutableAttributedString *prepend = [[NSMutableAttributedString alloc] initWithString:@"TAVOLO" attributes:mediumDict];
        
        UIFont *light = [UIFont fontWithName:@"Roboto-Thin" size:self.font.pointSize];
        NSDictionary *lightDict = [NSDictionary dictionaryWithObject:light forKey:NSFontAttributeName];
        NSMutableAttributedString *append = [[NSMutableAttributedString alloc] initWithString:@".IO" attributes:lightDict];
        
        [prepend appendAttributedString:append];
        
        self.attributedText = prepend;
    }
    else {
        self.font = [UIFont fontWithName:@"Roboto-Medium" size:self.font.pointSize];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
