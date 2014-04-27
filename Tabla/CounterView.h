//
// File: CounterView.h
// Authors: William Wettersten and Michael Xu
//
// View for counters to increment and decrement values
//

#import <Cocoa/Cocoa.h>

#import "PadView.h"

@interface CounterView : NSImageView
    @property (nonatomic, retain) IBOutlet NSTextField* label;
    - (void) up;
    - (void) down;
@end

@interface UpView : NSView
    @property (nonatomic, retain) IBOutlet CounterView* parent;
@end

@interface DownView : NSView
    @property (nonatomic, retain) IBOutlet CounterView* parent;
@end
