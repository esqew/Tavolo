//
//  DropDownViewController.m
//  Tavolo
//
//  Created by MAC on 4/14/15.
//  Copyright (c) 2015 Tavolo Team. All rights reserved.
//

#import "DropDownViewController.h"

#import "DropDownView.h"

#import <QuartzCore/QuartzCore.h>


@implementation DropDownViewController

@synthesize uiTableView;

@synthesize arrayData,heightOfCell,refView;

@synthesize paddingLeft,paddingRight,paddingTop;

@synthesize open,close;

@synthesize heightTableView;

- (id)initWithArrayData:(NSArray*)data cellHeight:(CGFloat)cHeight heightTableView:(CGFloat)tHeightTableView paddingTop:(CGFloat)tPaddingTop paddingLeft:(CGFloat)tPaddingLeft paddingRight:(CGFloat)tPaddingRight refView:(UIView*)rView animation:(AnimationType)tAnimation openAnimationDuration:(CGFloat)openDuration closeAnimationDuration:(CGFloat)closeDuration{
    
    if ((self = [super init])) {
        
        self.arrayData = data;
        
        self.heightOfCell = cHeight;
        
        self.refView = rView;
        
        self.paddingTop = tPaddingTop;
        
        self.paddingLeft = tPaddingLeft;
        
        self.paddingRight = tPaddingRight;
        
        self.heightTableView = tHeightTableView;
        
        self.open = openDuration;
        
        self.close = closeDuration;
        
        CGRect refFrame = refView.frame;
        
        self.view.frame = CGRectMake(refFrame.origin.x-paddingLeft,refFrame.origin.y+refFrame.size.height+paddingTop,refFrame.size.width+paddingRight, heightTableView);
        
        self.view.layer.shadowColor = [[UIColor blackColor] CGColor];
        
        self.view.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
        
        self.view.layer.shadowOpacity =1.0f;
        
        self.view.layer.shadowRadius = 5.0f;
        
        animationType = tAnimation;
        
    }
    
    return self;
    
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    CGRect refFrame = refView.frame;
    
    uiTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,refFrame.size.width+paddingRight, (animationType == BOTH || animationType == BLENDIN)?heightTableView:1) style:UITableViewStylePlain];
    
    uiTableView.dataSource = self;
    
    uiTableView.delegate = self;
    
    [self.view addSubview:uiTableView];
    
    self.view.hidden = YES;
    
    if(animationType == BOTH || animationType == BLENDIN)
        [self.view setAlpha:1];
    
    
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
}


- (void)dealloc {
    //[super dealloc];
    uiTableView = nil;
    arrayData = nil;
    refView = nil;
    
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return heightOfCell;
    
    
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
    
    return [arrayData count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    cell.textLabel.text = [arrayData objectAtIndex:indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self dropDownCellSelected:indexPath.row];
    
    [self closeAnimation];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return @"";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    
    return @"";
    
}

-(void)dropDownCellSelected:(NSInteger)returnIndex{
    
}

#pragma mark -
#pragma mark Class Methods


-(void)openAnimation{
    
    self.view.hidden = NO;
    
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:open];
    
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    [UIView setAnimationRepeatCount:1];
    
    [UIView setAnimationDelay:0];
    
    if(animationType == BOTH || animationType == GROW)
        self.uiTableView.frame = CGRectMake(uiTableView.frame.origin.x,uiTableView.frame.origin.y,uiTableView.frame.size.width, heightTableView);
    
    if(animationType == BOTH || animationType == BLENDIN)
        self.view.alpha = 1;
    
    [UIView commitAnimations];
    
}

-(void)closeAnimation{
    
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:close];
    
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    [UIView setAnimationRepeatCount:1];
    
    [UIView setAnimationDelay:0];
    
    if(animationType == BOTH || animationType == GROW)
        self.uiTableView.frame = CGRectMake(uiTableView.frame.origin.x,uiTableView.frame.origin.y,uiTableView.frame.size.width, 1);
    
    if(animationType == BOTH || animationType == BLENDIN)
        self.view.alpha = 0;
    
    [UIView commitAnimations];
    
    [self performSelector:@selector(hideView) withObject:nil afterDelay:close];
}


-(void)hideView{
    
    self.view.hidden = YES;
    
}	 


@end