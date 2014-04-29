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
        NSString *word = [self readline:[NSThread currentThread]];
        
        NSLog(word);

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
