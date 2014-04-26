//
//  SerialThread.h
//  Tabla
//
//  Created by William Wettersten on 3/4/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PadView.h"

@interface SerialThread : NSThread {
    IBOutlet PadView *pad;
}

@end
