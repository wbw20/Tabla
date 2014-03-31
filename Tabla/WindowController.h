#import <Cocoa/Cocoa.h>
#import "RootView.h"
#import "RootViewController.h"

@interface WindowController : NSWindowController
{
	IBOutlet RootView*	root;
	RootViewController*	controller;	// the current view controller
}

@end
