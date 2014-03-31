//
//  AppDelegate.h
//  Tabla
//
//  Created by William Wettersten on 1/31/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Sound.h"
#import "WindowController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    WindowController* windowController;
    NSMutableArray * soundData;
}

-(void)insertObject:(Sound *)s inSoundDataAtIndex:(NSInteger)index;
-(void)removeObjectFromSoundDataAtIndx:(NSUInteger)index;
-(void)setSoundData:(NSMutableArray *) a;
-(NSArray *)soundData;

-(void)awakeFromNib;
-(void)addSound:(NSURL *)url;

@property(retain, readwrite) NSMutableArray * soundData;

@end
