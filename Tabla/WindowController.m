//
//  WindowController.m
//  Tabla
//
//  Created by William Wettersten on 4/3/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import "WindowController.h"
#import "AppDelegate.h"

@implementation WindowController

- (void) addSound:(NSURL *) url {
    AppDelegate * ad = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    [ad addSound:url];
}

@end
