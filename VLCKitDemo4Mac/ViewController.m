//
//  ViewController.m
//  VLCKitDemo4Mac
//
//  Created by Matt Reach on 2019/3/5.
//  Copyright © 2019 Awesome VLC Study Demo. All rights reserved.
//

#import "ViewController.h"
#import <VLCKit/VLCKit.h>

@interface ViewController ()<VLCMediaPlayerDelegate>

@end

@implementation ViewController
{
    VLCMediaList* playlist;
    VLCMediaPlayer* player;
    VLCVideoView *videoView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Allocate a VLCVideoView instance and tell it what area to occupy.
// 使用 VLCVideoView 会导致鼠标事件被拦截；不能拖动背景移动窗口！！！
//    尝试使用以下方法屏蔽没有效果！
//        libvlc_video_set_mouse_input(_mlib,0);
//        libvlc_video_set_key_input(_mlib,0);

//    videoView = [[VLCVideoView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:videoView];
//    [videoView setAutoresizingMask: NSViewHeightSizable|NSViewWidthSizable];
    videoView.fillScreen = NO;
    
    
    [[VLCLibrary sharedLibrary] setDebugLogging:YES];
    [[VLCLibrary sharedLibrary] setDebugLoggingLevel:4];
    
    playlist = [[VLCMediaList alloc] init];
    player = [[VLCMediaPlayer alloc] initWithOptions:nil];
    player.drawable = self.view;
    player.delegate = self;
    
    // Do any additional setup after loading the view.
    
    NSArray *movies = @[@"http://10.7.36.50:8080/ffmpeg-test/ff-concat-2/test.ffcat",
                        @"http://debugly.cn/repository/test.mp4",
                        @"http://10.7.36.50:8080/ffmpeg-test/ff-concat-2/1.mp4",
                        @"http://10.7.36.50:8080/ffmpeg-test/ff-concat-2/2.mp4",
                        @"http://10.7.36.50:8080/ffmpeg-test/ff-concat-2/3.mp4"
                        ];
    for (NSString *movie in movies) {
        VLCMedia * media = [VLCMedia mediaWithURL:[NSURL URLWithString:movie]];
        [playlist addMedia:media];
    }
    
    [player setMedia:[playlist mediaAtIndex:1]];
    [player play];

// 倍速
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//        [player fastForwardAtRate:2];
//    });
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////        [player fastForwardAtRate:1];
//        [player fastForwardAtRate:0.5];
//    });

    [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        NSLog(@"===视频剩余：%@",[[player remainingTime]stringValue]);
        NSLog(@"===已播放：%@/%@",[[player time]stringValue],[[VLCTime timeWithInt:[[player time]intValue] - [[player remainingTime]intValue]]stringValue]);
    }];
    
}

- (void)mediaPlayerStateChanged:(NSNotification *)aNotification
{
    if (aNotification.object == player) {
        if(player.willPlay){
            CGSize ratio = player.videoSize;
            if (!CGSizeEqualToSize(CGSizeZero, ratio)) {
                CGRect rect = self.view.window.frame;
                [self.view.window setMovableByWindowBackground:YES];
                //根据尺寸进行锁定
                [self.view.window setAspectRatio:ratio];
                CGSize size = rect.size;
                size.height = player.videoSize.height / player.videoSize.width * size.width;
                rect.size = size;
                [self.view.window setFrame:rect display:YES animate:YES];
            }
        }
    }
}

@end
