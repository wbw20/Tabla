//
//  AppDelegate.m
//  Tabla
//
//  Created by William Wettersten on 1/31/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import "AppDelegate.h"
#import "SerialThread.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification*)notification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(close)
                                                 name:NSWindowWillCloseNotification
                                               object:window];
    
    
    SerialThread *thread = [[SerialThread alloc] init];
    [thread start];
}

- (void) close {
    [NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:0.0];
}

@end
