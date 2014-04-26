//
//  SerialThread.m
//  Tabla
//
//  Created by William Wettersten on 3/4/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import "SerialThread.h"
#import "SerialDelegate.h"

@implementation SerialThread

- (void)main {
    SerialDelegate *serial = [[SerialDelegate alloc] init];
    [serial listen:pad];
}

@end
