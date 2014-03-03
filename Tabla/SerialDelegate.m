//
//  SerialDelegate.m
//  Tabla
//
//  Created by William Wettersten on 3/2/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import "SerialDelegate.h"

#define BUFFER_SIZE 256

@implementation SerialDelegate

static int BAUDRATE = 9600;

int code = -1;
char quiet=0;
char eolchar = '\n';
int timeout = 5000;
int rc,n;

- (id) init {
    return self;
}

- (void) listen {
    if( code == -1 ) {
        NSLog(@"serial port not opened");
    }

    [self open];
    
    memset(buffer, 0, BUFFER_SIZE);
//    read(code, buffer, eolchar, BUFFER_SIZE, timeout);

    printf("%s\n", buffer);
}

- (int) open {
    return -1;
}

@end
