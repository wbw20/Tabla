//
//  UploadButton.m
//  Tabla
//
//  Created by William Wettersten on 4/16/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import "UploadButton.h"

@implementation UploadButton

- (id) initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setImage:[NSImage imageNamed:@"upload"]];
    }

    return self;
}

- (void) mouseDown:(NSEvent *)theEvent {
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"UploadClicked"
     object:self
     userInfo:nil];
}

- (void) resetCursorRects {
    [self addCursorRect:[self bounds] cursor:[NSCursor pointingHandCursor]];
}

@end
