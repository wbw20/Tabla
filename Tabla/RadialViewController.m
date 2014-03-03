//
//  RadialViewController.m
//  Tabla
//
//  Created by William Wettersten on 2/6/14.
//  Copyright (c) 2014 William Wettersten. All rights reserved.
//

#import "RadialViewController.h"
#import "AppDelegate.h"

@interface RadialViewController ()

@end

@implementation RadialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void) addSound:(NSURL *) url{
    AppDelegate * ad = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    [ad addSound:url];
}

@end
