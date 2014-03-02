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

/**
 *  Responds to click events
 */
- (void)test {
    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"tom1" ofType:@"aif"];
    NSSound *sound = [[NSSound alloc] initWithContentsOfFile:resourcePath byReference:YES];
    
    [sound play];
}

@end
