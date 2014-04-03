//
//  SoundView.m
//  Tabla
//
//  Created by Mike on 3/2/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import "SoundView.h"

@implementation SoundView

NSString *drag_id = @"com.tabla.soundDnD";

- (id) initWithCoder:(NSCoder *)coder {
    if ([super initWithCoder:coder]) {
        [self registerForDraggedTypes:[NSArray arrayWithObjects:NSURLPboardType, nil]];
    }
    
    return self;
}

-(void)drawRect:(NSRect)rect {
    NSRect bounds = [self bounds];
    
    // Fill the view with green
    [[NSColor blueColor] set];
    [NSBezierPath fillRect: bounds];
}

-(NSDragOperation) draggingEntered:(id<NSDraggingInfo>)sender {
    NSLog(@"Enter");
    return NSDragOperationCopy;
}

-(void) draggingExited:(id<NSDraggingInfo>)sender {
    NSLog(@"Exit");
}

-(void) draggingEnded:(id<NSDraggingInfo>)sender {
    NSLog(@"Ended");
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender
{
    NSURL* fileURL = [NSURL URLFromPasteboard: [sender draggingPasteboard]];
    if(fileURL != NULL) {
        NSLog(@"Dragged");
    }
    
    return NO;
}

@end
