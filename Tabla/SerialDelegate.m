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

int fd = -1;
char quiet=0;
char eolchar = '\n';
int timeout = 5000;
int rc,n;

- (id) init {
    return self;
}

- (void) listen {
    if( fd == -1 ) error("serial port not opened");
    memset(buffer,0,BUFFER_SIZE);  //
    serialport_read_until(fd, buffer, eolchar, BUFFER_SIZE, timeout);
    if( !quiet ) printf("read string:");
    printf("%s\n", buffer);
}

@end
