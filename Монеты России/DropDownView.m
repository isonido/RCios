    //
//  DropDownView.m
//  CustomTableView
//
//  Created by Ameya on 19/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DropDownView.h"

#import <QuartzCore/QuartzCore.h>


@implementation DropDownView

@synthesize uiTableView;

@synthesize arrayData,heightOfCell,refView;

@synthesize paddingLeft,paddingRight,paddingTop;

@synthesize open,close;

@synthesize heightTableView;

@synthesize delegate;



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
        //refView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 320.0f);
		
		self.view.frame = CGRectMake(refFrame.origin.x-paddingLeft,refFrame.origin.y+refFrame.size.height+paddingTop, refFrame.size.width+paddingRight, heightTableView);

		self.view.layer.shadowColor = [[UIColor blackColor] CGColor];
		
		self.view.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
		
		self.view.layer.shadowOpacity =0.5f;
		
		self.view.layer.shadowRadius = 4.0f;
		
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
    
    uiTableView.backgroundColor = [UIColor whiteColor];
	
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

/*
- (void)dealloc {
    [super dealloc];
	[uiTableView release];
	[arrayData,refView release];
	
}
*/
#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	return heightOfCell;
	
	
}	

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
	
	return [arrayData count];
	
}	

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	static NSString *CellIdentifier = @"Cellmini";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
        
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		
    }
    
	cell.textLabel.text = [arrayData objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor darkGrayColor];
    if (indexPath.row == 3|indexPath.row == 4) {
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    if (indexPath.row == 5|indexPath.row == 6) {
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    
	return cell;
	
}	

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	[delegate dropDownCellSelected:indexPath.row];
	
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

#pragma mark -
#pragma mark DropDownViewDelegate

-(void)dropDownCellSelected:(NSInteger)returnIndex{
	
}	

#pragma mark -
#pragma mark Class Methods


-(void)openAnimation{
	
	self.view.hidden = NO;
	
	NSValue *contextPoint = [NSValue valueWithCGPoint:self.view.center];
	
	[UIView beginAnimations:nil context:(__bridge void *)(contextPoint)];
	
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
	
	NSValue *contextPoint = [NSValue valueWithCGPoint:self.view.center];
	
	[UIView beginAnimations:nil context:(__bridge void *)(contextPoint)];
	
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
