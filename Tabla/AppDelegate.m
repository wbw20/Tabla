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
    NSLog(@"Application finished launching");
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
}

- (void) close {
    [NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:0.0];
}

@end
