//
//  SerialDelegate.h
//  Tabla
//
//  Created by William Wettersten on 3/2/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define BUFFER_SIZE 256

@interface SerialDelegate : NSObject {
    NSString *port;
}

- (void) listen;

@end
