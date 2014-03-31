//
//  RadialView.h
//  Tabla
//
//  Created by William Wettersten on 2/6/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PadViewController.h"

@interface PadView : NSView <NSDraggingDestination>
{
    IBOutlet PadViewController *controller;
    IBOutlet NSWindow *window;
    NSTrackingArea *trackingArea;
}

- (NSPoint)center;
- (void)redraw;

//TODO -- remove these
- (int) radial;
- (void) setRadial:(int)value;
- (int) concentric;
- (void) setConcentric:(int)value;
//END TODO

@end
