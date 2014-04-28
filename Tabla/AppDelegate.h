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
#import "WindowController.h"
#import "SerialThread.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    IBOutlet INAppStoreWindow* window;
    IBOutlet WindowController* controller;
    IBOutlet SerialThread *thread;
}

@property (assign) IBOutlet NSPanel *sheet;
@property IBOutlet NSTextField *status;
@property IBOutlet int progress;
@property NSArray *myArray;

- (IBAction)showSheetAction:(id)sender;
- (IBAction)doneSheetAction:(id)sender;

- (void)openDocument:(id)sender;

@end
