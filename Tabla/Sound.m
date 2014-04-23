//
//  SoundModel.m
//  Tabla
//
//  Created by Mike on 3/2/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import "Sound.h"

@implementation Sound

@synthesize name;
@synthesize filepath;
@synthesize color;

- (id) initWithPath:(NSURL*)url {
    if ([super initWithContentsOfFile:[url path] byReference:YES]) {
        self.filepath = url;
        self.name = [url lastPathComponent];
        float r = (float)rand() / RAND_MAX;
        float g = (float)rand() / RAND_MAX;
        float b = (float)rand() / RAND_MAX;
        self.color = [NSColor colorWithRed:r green:g blue:b alpha:1.0f];
    }

    return self;
}

- (NSString*) toString {
    return [NSString stringWithFormat:@"%@:%@", [self name], [[self filepath] path]];
}

@end
