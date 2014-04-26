//
// File: Sound.h
// Authors: Michael Xu
//
// Model for sound data
// Specifies the file name and path of the sound
// Associate a display color for the sound
//

#import <Foundation/Foundation.h>

@interface Sound : NSSound

@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSURL *filepath;
@property(nonatomic, retain) NSColor *color;

// constructor for the file URL and color
- (id)initWithPath:(NSURL *)url andColor:(NSColor *)color;

// returns a string representation of the data
- (NSString *)toString;

@end
