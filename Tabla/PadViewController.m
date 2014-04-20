//
//  PadViewController.m
//  Tabla
//
//  Created by William Wettersten on 2/6/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import "PadViewController.h"
#import "AppDelegate.h"

@implementation PadViewController

- (BOOL)playSoundForRadial:(NSInteger)radial andConcentric:(NSInteger)concentric {
    return [windowController playSoundForRadial:radial andConcentric:concentric];
}

- (void)addSound:(NSURL *) url atRadial:(NSInteger)radial andContentric:(NSInteger)concentric {
    [windowController addSound:url atRadial:radial andContentric:concentric];
}

@end
