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

int code = -1;
char quiet=0;

- (id) init {
    return self;
}

- (void) listen {
    if( code == -1 ) {
        NSLog(@"serial port not opened");
    }

    code = [self connect];
    
//    memset(buffer, 0, BUFFER_SIZE);

    printf("%c\n", [self read_char]);
}

- (char) read_char {
    char single[1]; // single char array at a time
    int i = 0;
    while(i < BUFFER_SIZE) {
        long result = read(code, single, 1);

        if (result == -1) {
            return -1;
        }

        if (result != 0) {
            return single[0];
        }
    }
    
    return -1; // this should never happen
}

- (int) connect {
    return open(serialport, O_RDWR | O_NONBLOCK );
}

- (int) disconnect {
    return close(code);
}

@end
