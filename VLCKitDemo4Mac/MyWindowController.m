//
//  MyWindowController.m
//  VLCKitDemo4Mac
//
//  Created by Matt Reach on 2019/3/8.
//  Copyright © 2019 Awesome VLC Study Demo. All rights reserved.
//

#import "MyWindowController.h"

@interface MyWindowController ()

@end

@implementation MyWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    ///设置可拖动背景移动窗口
    [self.window setMovableByWindowBackground:YES];
}

@end
