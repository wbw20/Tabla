//
//  AppDelegate.m
//  Tabla
//
//  Created by William Wettersten on 1/31/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import "AppDelegate.h"
#import "SerialThread.h"
#import "UploadButton.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification*)notification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(close)
                                                 name:NSWindowWillCloseNotification
                                               object:window];
    [self setupToolbar];
    [thread start];
}

- (void) setupToolbar {
    window.trafficLightButtonsLeftMargin = 7.0;
    window.centerTrafficLightButtons = FALSE;
	window.fullScreenButtonRightMargin = 7.0;
	window.centerFullScreenButton = YES;
	window.titleBarHeight = 55.0;
    
    //Draw the upload icon
    NSView *titleBarView = window.titleBarView;
	NSSize segmentSize = NSMakeSize(40, 40);
	NSRect segmentFrame = NSMakeRect(titleBarView.bounds.size.width - (segmentSize.width + 10.0), NSMidY(titleBarView.bounds) - (segmentSize.height / 2.f), segmentSize.width, segmentSize.height);
    
    UploadButton* upload = [[UploadButton alloc] initWithFrame:segmentFrame];
    
    [titleBarView addSubview:upload];
    
    // listen to notification showing the upload sheet
    [[NSNotificationCenter defaultCenter]
     addObserverForName:@"UploadClicked"
     object:nil
     queue:nil
     usingBlock:^(NSNotification *note) {
         [self showSheetAction:[note object]];
     }];
    
    [self setMyArray:@[@"Connecting", @"Fetching", @"Compiling sounds", @"Compiling sounds", @"Compiling sounds", @"Compiling sounds", @"Optimizing", @"Done"]];
}

- (IBAction)showSheetAction:(id)sender {
    [[self status] setStringValue:[[self myArray] objectAtIndex:0]];
    [self setProgress:0];
	[NSApp beginSheet:self.sheet modalForWindow:window
		modalDelegate:self didEndSelector:nil contextInfo:nil];
    [self fakeLoad:sender];
}

- (IBAction)doneSheetAction:(id)sender {
	[self.sheet orderOut:nil];
	[NSApp endSheet:self.sheet];
}

- (void) fakeLoad:(id)sender {
    //Create the block that we wish to run on a different thread.
    void (^progressBlock)(void);
    progressBlock = ^{
        while ([self progress] < 110) { // 110 out of 100 because of animation hack
            [NSThread sleepForTimeInterval:0.02];
            [self setProgress:[self progress] + 1];
            [[self status] setStringValue:[[self myArray] objectAtIndex:(([[self myArray] count] - 1) * [self progress] / 110)]];
        }
        
        [self doneSheetAction:sender];
    };
    
    //Finally, run the block on a different thread.
    dispatch_queue_t queue = dispatch_get_global_queue(0,0);
    dispatch_async(queue,progressBlock);
}

- (void)openDocument:(id)sender {
    [controller loadProfile:nil];
}

- (void) close {
    [NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:0.0];
}

@end
