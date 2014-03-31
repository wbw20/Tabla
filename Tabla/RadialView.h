//
//  RadialView.h
//  Tabla
//
//  Created by William Wettersten on 2/6/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class RadialViewController;

@interface RadialView : NSView <NSDraggingDestination>
{
    IBOutlet RadialViewController *controller;
    IBOutlet NSWindow *window;
    NSTrackingArea *trackingArea;
}

@property int radial;
@property int concentric;

- (NSPoint)center;
- (void)drawZones;

@end
