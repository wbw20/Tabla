//
//  RadialViewController.m
//  Tabla
//
//  Created by William Wettersten on 2/6/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import "RadialViewController.h"

@interface RadialViewController ()

@end

@implementation RadialViewController

- (id)init {
    self = [super init];
    if (self) {
        NSView *view = [self view];
    }
    return self;
}

- (void) test {
    NSLog(@"it works");
}

/**
 *  Responds to click events
 */
- (void)mouseUp: (NSEvent *)event {
    [self test];
    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"tom1" ofType:@"aif"];
    NSSound *sound = [[NSSound alloc] initWithContentsOfFile:resourcePath byReference:YES];
    
    [sound play];
}

@end
