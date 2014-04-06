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

/**
 *  Responds to click events
 */
- (void)test {
    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"tom1" ofType:@"aif"];
    NSSound *sound = [[NSSound alloc] initWithContentsOfFile:resourcePath byReference:YES];
    
    [sound play];
}

-(void)addSound:(NSURL *) url atRadial:(NSInteger)radial andContentric:(NSInteger)concentric {
    [windowController addSound:url atRadial:radial andContentric:concentric];
}

- (NSInteger) radial {
    return [windowController radial];
}

- (void) setRadial:(NSInteger)radial {
    [windowController setRadial:radial];
}

- (NSInteger) concentric {
    return [windowController concentric];
}

- (void) setConcentric:(NSInteger)concencric {
    [windowController setConcentric:concencric];
}

@end
