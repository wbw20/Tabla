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

-(NSDragOperation) draggingEntered:(id<NSDraggingInfo>)sender {
    return NSDragOperationCopy;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender {
    NSURL* fileURL = [NSURL URLFromPasteboard: [sender draggingPasteboard]];
    if(fileURL != NULL) {
        NSLog(@"Sound dropped in library");
        Sound *s = [[Sound alloc] initWithPath:fileURL];
        [windowController addSound:s];
        return YES;
    }
    
    return NO;
}

@end
