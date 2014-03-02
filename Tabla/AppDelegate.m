//
//  AppDelegate.m
//  Tabla
//
//  Created by William Wettersten on 1/31/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import "AppDelegate.h"
#import "WindowController.h"

@implementation AppDelegate

@synthesize soundData;

- (void)applicationDidFinishLaunching:(NSNotification*)notification
{
	if (windowController == NULL)
		windowController = [[WindowController alloc] initWithWindowNibName:@"Radial"];
	
	[windowController showWindow:self];
}

-(void)insertObject:(SoundModel *)s inSoundDataAtIndex:(NSInteger)index {
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
    SoundModel *s = [[SoundModel alloc] init];
    s.name = @"First Sound";
    s.filepath = [NSURL fileURLWithPath:@"~\\npm-debug.log"];
    NSMutableArray * tempData = [NSMutableArray arrayWithObjects:s, nil];
    [self setSoundData:tempData];
}

-(void)addSound:(NSURL *) url{
    SoundModel *s = [[SoundModel alloc] init];
    s.name = @"New Sound";
    s.filepath = url;
    NSLog(@"add sound");
    NSMutableArray * tempData = [NSMutableArray arrayWithArray:self.soundData];
    [tempData addObject:s];
    [self setSoundData:tempData];
}

@end
