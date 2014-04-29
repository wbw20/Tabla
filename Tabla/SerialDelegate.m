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
    
//    [self incomingTextUpdateThread:[NSThread currentThread]];

    while(1) {
        NSString *word = [self readword];

        if (![word isEqual:@""]) {
            NSLog(word);
            NSArray *parts = [word componentsSeparatedByString:@","];
            
            if ([parts count] >= 2) {
                int x = [[[parts objectAtIndex:0] substringWithRange:NSMakeRange(1, [[parts objectAtIndex:0] length] - 1)]floatValue];
                int y = [[[parts objectAtIndex:1] substringWithRange:NSMakeRange(0, [[parts objectAtIndex:1] length] - 2)] floatValue];
                
//                NSPoint point = [[self pad]convertPoint:CGPointMake((x * 5) + 250, (y * 5) + 250) fromView:nil];
//                
//                int radial = [[self pad] getRadial:point];
//                int concentric = [[self pad] getConcentric:point];
                
                int radial = 1;
                int concentric = 1;
                
                if (x == 57 && y == 16) {
                    concentric = 2;
                    radial = 1;
                }
                
                if (x == 69 && y == 21) {
                    concentric = 2;
                    radial = 1;
                }
                
                if (x == 79 && y == 31) {
                    concentric = 2;
                    radial = 2;
                }
                
                if (x == 84 && y == 43) {
                    concentric = 2;
                    radial = 2;
                }
                
                if (x == 84 && y == 57) {
                    concentric = 2;
                    radial = 3;
                }
                
                if (x == 79 && y == 69) {
                    concentric = 2;
                    radial = 3;
                }
                
                if (x == 57 && y == 84) {
                    concentric = 2;
                    radial = 4;
                }
                
                if (x == 50 && y == 50) {
                    concentric = 1;
                    radial = 1;
                }
                
                if (x == 43 && y == 84) {
                    concentric = 2;
                    radial = 4;
                }
                
                if (x == 31 && y == 79) {
                    concentric = 2;
                    radial = 5;
                }
                
                if (x == 21 && y == 69) {
                    concentric = 2;
                    radial = 5;
                }
                
                if (x == 16 && y == 57) {
                    concentric = 2;
                    radial = 6;
                }
                
                if (x == 16 && y == 43) {
                    concentric = 2;
                    radial = 6;
                }
                
                if (x == 21 && y == 31) {
                    concentric = 2;
                    radial = 7;
                }
                
                if (x == 31 && y == 21) {
                    concentric = 2;
                    radial = 7;
                }
                
                if (x == 43 && y == 16) {
                    concentric = 2;
                    radial = 8;
                }
                
                NSDictionary *userInfo = @{@"radial": [NSNumber numberWithInt:concentric],
                                           @"concentric": [NSNumber numberWithInt:radial]};
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"ZoneClicked"
                 object:self
                 userInfo:userInfo];
            }
        }
    }
}

- (NSString*)readword {
    NSMutableString *buffer = [[NSMutableString alloc] initWithString:@""];
    NSString *chunk = [self readline:[NSThread currentThread]];
    
    if (!([chunk rangeOfString:@"["].location == NSNotFound)) {
        while(1) {
            if (![chunk  isEqual: @""]) {
                [buffer appendString:chunk];
            }
            
            if (!([chunk rangeOfString:@"]"].location == NSNotFound)) {
                break;
            }

            chunk = [self readline:[NSThread currentThread]];
        }
    }
    
    return [NSString stringWithString:buffer];
}

// This selector will be called as another thread
- (NSString*)readline: (NSThread *) parentThread {
    char byte_buffer[100]; // buffer for holding incoming data
    int numBytes=1; // number of bytes read during read
    NSMutableString *buffer = [[NSMutableString alloc] initWithString:@""];
    
    numBytes = read(code, byte_buffer, 100);
    
    while(numBytes > 0) {
        [buffer appendString:[NSString stringWithCString:byte_buffer length:numBytes]];
        numBytes = read(code, byte_buffer, 100);
    }
    
    return buffer;
}

- (int) connect {
    return open([port UTF8String], O_RDWR | O_NONBLOCK );
}

- (int) disconnect {
    return close(code);
}

@end
