//
//  SerialDelegate.h
//  Tabla
//
//  Created by William Wettersten on 3/2/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PadView.h"

@interface SerialDelegate : NSObject {
    NSString *port;
}

@property PadView *pad;

- (void) listen:(PadView*)view;

@end
