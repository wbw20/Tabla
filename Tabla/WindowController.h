#import <Cocoa/Cocoa.h>
#import "RootView.h"

@interface WindowController : NSWindowController
{
	IBOutlet RootView*	myTargetView;				// the host view
	NSViewController*	myCurrentViewController;	// the current view controller
}

- (IBAction)viewChoicePopupAction:(id)sender;
- (NSViewController*)viewController;

@end
