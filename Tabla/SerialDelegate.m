//
//  SerialDelegate.m
//  Tabla
//
//  Created by William Wettersten on 3/2/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import "SerialDelegate.h"

@implementation SerialDelegate

int code = -1;

- (id) init {
    port = @"/dev/tty.usbmodem1411";
    
    return self;
}

- (void) listen:(PadView*)view {
    code = [self connect];
    [self setPad:view];

    if( code == -1 ) {
        NSLog(@"serial port not opened");
    }

    while(1) {
        NSString *word = [self read_char];

        if (![word isEqual:@""]) {
            NSArray *parts = [word componentsSeparatedByString:@","];
            
            if ([parts count] >= 2) {
                int concentric = [[[parts objectAtIndex:0] substringWithRange:NSMakeRange(1, [[parts objectAtIndex:0] length] - 1)]floatValue];
                int radial = [[[parts objectAtIndex:1] substringWithRange:NSMakeRange(0, [[parts objectAtIndex:1] length] - 2)] floatValue];
                
                NSDictionary *userInfo = @{@"radial": [NSNumber numberWithInt:concentric + 1],
                                           @"concentric": [NSNumber numberWithInt:radial + 1]};
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"ZoneClicked"
                 object:self
                 userInfo:userInfo];
            }
        }
    }
}

- (NSString*) read_char {
    char single[1];
    char chars[9]; // single char array at a time
    int count = 0;
    long status;
        
    while (single[0] != ']' && status != -1l) {
        status = read(code, single, 1);
        chars[count] = single[0];
        count++;
    }

    return [NSString stringWithCString:chars encoding:NSASCIIStringEncoding];
}

- (int) connect {
    return open([port UTF8String], O_RDWR | O_NONBLOCK );
}

- (int) disconnect {
    return close(code);
}

@end
