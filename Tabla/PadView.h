//
//  RadialView.h
//  Tabla
//
//  Created by William Wettersten on 2/6/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PadView : NSView <NSDraggingDestination>
{
    NSTrackingArea *trackingArea;
}

- (int)getRadial:(NSPoint)loc;
- (int)getConcentric:(NSPoint)loc;

@end
