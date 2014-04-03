//
//  SoundModel.m
//  Tabla
//
//  Created by Mike on 3/2/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import "Sound.h"

@implementation Sound

- (id) initWithPath:(NSURL*)path {
    if ([super init]) {
        [self setFilepath:path];
    }

    return self;
}

@end
