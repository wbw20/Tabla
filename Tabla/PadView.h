//
// File: PadView.h
// Authors: Michael Xu
//
// View for rendering the zones of the pad
//

#import <Cocoa/Cocoa.h>

@interface PadView : NSView <NSDraggingDestination>
{
    // area to track mouse movement for mouseovers
    NSTrackingArea *trackingArea;
}

// expose methods for converting screen location to zone coordinates
- (int)getRadial:(NSPoint)loc;
- (int)getConcentric:(NSPoint)loc;

@end
