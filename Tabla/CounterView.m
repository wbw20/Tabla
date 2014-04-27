//
// File: CounterView.h
// Authors: William Wettersten and Michael Xu
//
// View for counters to increment and decrement values
//

#import "CounterView.h"

@implementation UpView

- (void)drawRect:(NSRect)dirtyRect {
	[super drawRect:dirtyRect];
    [[NSImage imageNamed:@"plus.png"] drawInRect:dirtyRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
}

- (void) mouseUp:(NSEvent *)event {
    [[self parent] up];
}

- (void) resetCursorRects {
    [self addCursorRect:[self bounds] cursor:[NSCursor pointingHandCursor]];
}

@end

@implementation DownView

- (void)drawRect:(NSRect)dirtyRect {
	[super drawRect:dirtyRect];
    [[NSImage imageNamed:@"minus.png"] drawInRect:dirtyRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
}

- (void) mouseUp:(NSEvent *)event {
    [[self parent] down];
}

- (void) resetCursorRects {
    [self addCursorRect:[self bounds] cursor:[NSCursor pointingHandCursor]];
}

@end

@implementation CounterView

- (void)drawRect:(NSRect)dirtyRect {
	[super drawRect:dirtyRect];}

- (void)displayValue:(NSInteger)value {
    [[self label] setStringValue:@(value).stringValue];
}

// virtual methods to be overriden by subclasses
- (void)up {
    @throw [NSException
            exceptionWithName:NSInternalInconsistencyException
            reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
            userInfo:nil
            ];
}

- (void)down {
    @throw [NSException
            exceptionWithName:NSInternalInconsistencyException
            reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
            userInfo:nil
            ];
}

@end

#pragma mark Radial Counter

@interface RadialCounterView : CounterView
@end

@implementation RadialCounterView: CounterView

// override default constructor for NSImageView
- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if(!self) return nil;
    // register NSNotification for updating radial
    [[NSNotificationCenter defaultCenter]
     addObserverForName:@"UpdateRadial"
     object:nil
     queue:nil
     usingBlock:^(NSNotification *note) {
         [super displayValue:[[[note userInfo] objectForKey:@"radial"] integerValue]];
     }];
    return self;
}

- (void)up {
    // send a notification to try incrementing radial
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"TryIncrementRadial"
     object:self
     ];
}

- (void)down {
    // send a notification to try decrementing radial
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"TryDecrementRadial"
     object:self
     ];
}

@end

#pragma mark Concentric Counter

@interface ConcentricCounterView : CounterView
@end

@implementation ConcentricCounterView

// override default constructor for NSImageView
- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if(!self) return nil;
    // register NSNotification for updating radial
    [[NSNotificationCenter defaultCenter]
     addObserverForName:@"UpdateConcentric"
     object:nil
     queue:nil
     usingBlock:^(NSNotification *note) {
         [super displayValue:[[[note userInfo] objectForKey:@"concentric"] integerValue]];
     }];
    return self;
}


- (void)up {
    // send a notification to try incrementing concentric
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"TryIncrementConcentric"
     object:self
     ];
}

- (void)down {
    // send a notification to try decrementing concentric
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"TryDecrementConcentric"
     object:self
     ];
}

@end

