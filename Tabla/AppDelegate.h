//
//  AppDelegate.h
//  Tabla
//
//  Created by William Wettersten on 1/31/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Sound.h"
#import "INAppStoreWindow.h"
#import "SerialThread.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    IBOutlet INAppStoreWindow* window;
    IBOutlet SerialThread *thread;
}

@property (assign) IBOutlet NSPanel *sheet;
@property IBOutlet int progress;

- (IBAction)showSheetAction:(id)sender;
- (IBAction)doneSheetAction:(id)sender;

@end
