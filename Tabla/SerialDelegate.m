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
    port = @"/dev/tty.usbmodem1421";
    
    return self;
}

- (void) listen:(PadView*)view {
    code = [self connect];
    [self setPad:view];

    if( code == -1 ) {
        NSLog(@"serial port not opened");
    }

     [self read_char];
}

- (char) read_char {
    NSMutableString *buffer = [[NSMutableString alloc] initWithString:@""];
    unichar *single[1]; // single char array at a time
    while(1) {
        long result = read(code, single, 1);
        
        if (result != -1) {
            [buffer appendString:[NSString stringWithCharacters:single length:1]];
        }
        
        if (single[0] == ']' && [buffer length] > 0) {
            NSArray *parts = [buffer componentsSeparatedByString:@", "];
            int x = [[[parts objectAtIndex:0] substringWithRange:NSMakeRange(1, [[parts objectAtIndex:0] length] - 1)] floatValue];
            int y = [[[parts objectAtIndex:1] substringWithRange:NSMakeRange(0, [[parts objectAtIndex:1] length] - 2)] floatValue];
            
            NSPoint point = CGPointMake(500 * x, 500 * y);
            
            NSDictionary *userInfo = @{@"radial": [NSNumber numberWithInt:[[self pad] getRadial:point]],
                                           @"concentric": [NSNumber numberWithInt:[[self pad] getConcentric:point]]};
            [[NSNotificationCenter defaultCenter]
            postNotificationName:@"ZoneClicked"
            object:self
            userInfo:userInfo];
            
            buffer = [[NSMutableString alloc] initWithString:@""];
        }
    }
    
    return -1; // this should never happen
}

- (int) connect {
    return open([port UTF8String], O_RDWR | O_NONBLOCK );
}

- (int) disconnect {
    return close(code);
}

@end
