#import "WindowController.h"

@implementation WindowController

enum	// popup tag choices
{
	kImageView = 0,
	kTableView,
	kVideoView,
	kCameraView
};

NSString *const kViewTitle		= @"CustomImageView";

// -------------------------------------------------------------------------------
//	initWithPath:newPath
// -------------------------------------------------------------------------------
- initWithPath:(NSString *)newPath
{
    NSLog(@"fuck");
    return [super initWithWindowNibName:@"Tabla"];
}

// -------------------------------------------------------------------------------
//	changeViewController:whichViewTag
//
//	Change the current NSViewController to a new one based on a tag obtained from
//	the NSPopupButton control.
// -------------------------------------------------------------------------------
- (void)changeViewController:(NSInteger)whichViewTag
{
	// we are about to change the current view controller,
	// this prepares our title's value binding to change with it
	[self willChangeValueForKey:@"viewController"];
	
	if ([myCurrentViewController view] != nil)
		[[myCurrentViewController view] removeFromSuperview];	// remove the current view
    
	if (myCurrentViewController != nil)
//		[myCurrentViewController release];		// remove the current view controller
	
	
	// embed the current view to our host view
	[myTargetView addSubview: [myCurrentViewController view]];
	
	// make sure we automatically resize the controller's view to the current window size
	[[myCurrentViewController view] setFrame: [myTargetView bounds]];
	
	// set the view controller's represented object to the number of subviews in that controller
	// (our NSTextField's value binding will reflect this value)
	[myCurrentViewController setRepresentedObject: [NSNumber numberWithUnsignedInt: [[[myCurrentViewController view] subviews] count]]];
	
	[self didChangeValueForKey:@"viewController"];	// this will trigger the NSTextField's value binding to change
}

// -------------------------------------------------------------------------------
//	awakeFromNib:
// -------------------------------------------------------------------------------
- (void)awakeFromNib
{
	[self changeViewController: kImageView];
}

// -------------------------------------------------------------------------------
//	viewChoicePopupAction
// -------------------------------------------------------------------------------
- (IBAction)viewChoicePopupAction:(id)sender
{
	[self changeViewController: [[sender selectedCell] tag]];
}

// -------------------------------------------------------------------------------
//	viewController
// -------------------------------------------------------------------------------
- (NSViewController*)viewController
{
	return myCurrentViewController;
}

@end
