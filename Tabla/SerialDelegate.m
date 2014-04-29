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
    
//    [self incomingTextUpdateThread:[NSThread currentThread]];

    while(1) {
        [self incomingTextUpdateThread:[NSThread currentThread]];
////        NSString *word = [self read_char];
//
//        if (![word isEqual:@""]) {
//            NSArray *parts = [word componentsSeparatedByString:@","];
//            
//            if ([parts count] >= 2) {
//                int concentric = [[[parts objectAtIndex:0] substringWithRange:NSMakeRange(1, [[parts objectAtIndex:0] length] - 1)]floatValue];
//                int radial = [[[parts objectAtIndex:1] substringWithRange:NSMakeRange(0, [[parts objectAtIndex:1] length] - 2)] floatValue];
//                
//                NSDictionary *userInfo = @{@"radial": [NSNumber numberWithInt:concentric + 1],
//                                           @"concentric": [NSNumber numberWithInt:radial + 1]};
//                [[NSNotificationCenter defaultCenter]
//                 postNotificationName:@"ZoneClicked"
//                 object:self
//                 userInfo:userInfo];
//            }
//        }
    }
}

// This selector will be called as another thread
- (void)incomingTextUpdateThread: (NSThread *) parentThread {
    char byte_buffer[100]; // buffer for holding incoming data
    int numBytes=1; // number of bytes read during read
    
    // create a pool so we can use regular Cocoa stuff
    //   child threads can't re-use the parent's autorelease pool
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // this will loop until the serial port closes
    while(numBytes>0) {
        // read() blocks until data is read or the port is closed
        numBytes = read(code, byte_buffer, 100);
        
        // you would want to do something useful here
        NSLog([NSString stringWithCString:byte_buffer length:numBytes]);
    }
    
    // give back the pool
//    [pool release];
}

- (int) connect {
    return open([port UTF8String], O_RDWR | O_NONBLOCK );
}

- (int) disconnect {
    return close(code);
}

@end
