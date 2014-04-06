//
//  SoundModel.m
//  Tabla
//
//  Created by Mike on 3/2/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import "Sound.h"

@implementation Sound

- (id) initWithPath:(NSURL*)filepath {
    if ([super initWithContentsOfFile:[filepath path] byReference:YES]) {
        // nothing for now
    }

    return self;
}

@end
