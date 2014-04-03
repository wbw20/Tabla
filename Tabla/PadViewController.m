//
//  RadialViewController.m
//  Tabla
//
//  Created by William Wettersten on 2/6/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import "PadViewController.h"
#import "AppDelegate.h"

@implementation PadViewController

- (id) init {
    self = [super init];
    
    if (self) {
        [self setConcentric:1];
        [self setRadial:1];
    }
    
    return self;
}

/**
 *  Responds to click events
 */
- (void)test {
    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"tom1" ofType:@"aif"];
    NSSound *sound = [[NSSound alloc] initWithContentsOfFile:resourcePath byReference:YES];
    
    [sound play];
}

- (void) addSound:(NSURL *) url {
    return [windowController addSound:url];
}

@end
