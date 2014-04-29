//
// File: Sound.m
// Authors: Michael Xu
//
// Model for sound data
// Specifies the file name and path of the sound
// Associate a display color for the sound
//

#import "Sound.h"

@implementation Sound

@synthesize name;
@synthesize filepath;
@synthesize color;

// construct with given file URL and color
- (id)initWithPath:(NSURL *)url andColor:(NSColor *)c {
    if([super initWithContentsOfFile:[url path] byReference:YES]) {
        self.filepath = url;
        self.name = [url lastPathComponent];
        self.color = c;
    }
    return self;
}

// returns a string representation of the object
- (NSString *)toString {
    return [filepath absoluteString];
}

@end
