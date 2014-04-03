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
    [[self profile] addSound:url];
}

- (NSInteger) radial {
    return [[self profile] radial];
}

- (void) setRadial:(NSInteger)radial {
    [[self profile] setRadial:radial];
}

- (NSInteger) concentric {
    return [[self profile] concentric];
}

- (void) setConcentric:(NSInteger)concencric {
    [[self profile] setConcentric:concencric];
}

@end
