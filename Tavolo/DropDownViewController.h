//
//  DropDownViewController.h
//  Tavolo
//
//  Created by MAC on 4/14/15.
//  Copyright (c) 2015 Tavolo Team. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    BLENDIN,
    GROW,
    BOTH
} AnimationType;

@interface DropDownViewController : UIViewController<UITableViewDelegate,UITableViewDataSource> {
    
    UITableView *uiTableView;
    
    NSArray *arrayData;
    
    CGFloat heightOfCell;
    
    CGFloat paddingLeft;
    
    CGFloat paddingRight;
    
    CGFloat paddingTop;
    
    CGFloat heightTableView;
    
    UIView *refView;
    
    NSInteger animationType;
    
    CGFloat open;
    
    CGFloat close;
    
}

@property (nonatomic,retain)UITableView *uiTableView;

@property (nonatomic,retain) NSArray *arrayData;

@property (nonatomic) CGFloat heightOfCell;

@property (nonatomic) CGFloat paddingLeft;

@property (nonatomic) CGFloat paddingRight;

@property (nonatomic) CGFloat paddingTop;

@property (nonatomic) CGFloat heightTableView;

@property (nonatomic,retain)UIView *refView;

@property (nonatomic) CGFloat open;

@property (nonatomic) CGFloat close;

- (id)initWithArrayData:(NSArray*)data cellHeight:(CGFloat)cHeight heightTableView:(CGFloat)tHeightTableView paddingTop:(CGFloat)tPaddingTop paddingLeft:(CGFloat)tPaddingLeft paddingRight:(CGFloat)tPaddingRight refView:(UIView*)rView animation:(AnimationType)tAnimation  openAnimationDuration:(CGFloat)openDuration closeAnimationDuration:(CGFloat)closeDuration;

-(void)dropDownCellSelected:(NSInteger)returnIndex;

-(void)closeAnimation;

-(void)openAnimation;

@end

