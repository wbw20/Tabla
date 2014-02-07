#import <Cocoa/Cocoa.h>

@interface WindowController : NSWindowController
{
	IBOutlet NSView*	myTargetView;				// the host view
	NSViewController*	myCurrentViewController;	// the current view controller
}

- (IBAction)viewChoicePopupAction:(id)sender;
- (NSViewController*)viewController;

@end
