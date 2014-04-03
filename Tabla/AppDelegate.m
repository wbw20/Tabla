//
//  AppDelegate.m
//  Tabla
//
//  Created by William Wettersten on 1/31/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import "AppDelegate.h"
#import "PadViewController.h"
#import "SerialThread.h"

@implementation AppDelegate

@synthesize soundData;

- (void)applicationDidFinishLaunching:(NSNotification*)notification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(close)
                                                 name:NSWindowWillCloseNotification
                                               object:window];
    
    
    SerialThread *thread = [[SerialThread alloc] init];
    [thread start];
}

- (void) close {
    [NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:0.0];
}

-(void)insertObject:(Sound *)s inSoundDataAtIndex:(NSInteger)index {
    [soundData insertObject:s atIndex:index];
}
-(void)removeObjectFromSoundDataAtIndx:(NSUInteger)index {
    [soundData removeObjectAtIndex:index];
}
-(void)setSoundData:(NSMutableArray *) a {
    soundData = a;
}
-(NSArray *)soundData {
    return soundData;
}

-(void)awakeFromNib {
    NSMutableArray * tempData = [[NSMutableArray alloc] init];
    [self setSoundData:tempData];
}

-(void)addSound:(NSURL *) url{
    NSMutableArray * tempData = [NSMutableArray arrayWithArray:self.soundData];
    Sound *s = [[Sound alloc] init];
    s.name = [NSString stringWithFormat:@"Sound %lu", (unsigned long)tempData.count];
    s.filepath = url;
    NSLog(@"Added %@", s.name);
    [tempData addObject:s];
    [self setSoundData:tempData];
}

@end
