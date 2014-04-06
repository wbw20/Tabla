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

/*
 *  Default constructor uses a new profile
 */
- (id) init {
    Profile* model = [[Profile alloc] init];

    if ([super init]) {
        [self setProfile:model];
    }
    
    return self;
}

- (id) initWithProfile:(Profile*)model {
    if ([super init]) {
        [self setProfile:model];
    }

    return self;
}

- (void)addSound:(NSURL *) url atRadial:(NSInteger)radial andContentric:(NSInteger)concentric {
    [[self profile] addSound:url atRadial:radial andContentric:concentric];
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
