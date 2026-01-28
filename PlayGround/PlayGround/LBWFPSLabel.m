//
//  LBWFPSLabel.m
//  PlayGround
//
//  Created by zjs on 2026/1/27.
//

#import "LBWFPSLabel.h"

@interface LBWFPSLabel ()
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) NSTimeInterval lastTimestamp;
@property (nonatomic, assign) NSInteger count;
@end

@implementation LBWFPSLabel

+ (instancetype)showFPSLabelInView:(UIView *)view {
    LBWFPSLabel *fpsLabel = [[LBWFPSLabel alloc] init];
    fpsLabel.frame = CGRectMake(20, 100, 80, 30);
    fpsLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    fpsLabel.textColor = [UIColor whiteColor];
    fpsLabel.font = [UIFont boldSystemFontOfSize:14];
    fpsLabel.textAlignment = NSTextAlignmentCenter;
    fpsLabel.layer.cornerRadius = 5;
    fpsLabel.clipsToBounds = YES;
    fpsLabel.text = @"FPS: --";
    
    [view addSubview:fpsLabel];
    [fpsLabel startMonitoring];
    
    return fpsLabel;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _count = 0;
        _lastTimestamp = 0;
    }
    return self;
}

- (void)startMonitoring {
    if (_displayLink) {
        return;
    }
    
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopMonitoring {
    if (_displayLink) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
}

- (void)tick:(CADisplayLink *)displayLink {
    if (_lastTimestamp == 0) {
        _lastTimestamp = displayLink.timestamp;
        return;
    }
    
    _count++;
    NSTimeInterval delta = displayLink.timestamp - _lastTimestamp;
    
    // 每秒更新一次
    if (delta >= 1.0) {
        NSInteger fps = (NSInteger)(_count / delta);
        _count = 0;
        _lastTimestamp = displayLink.timestamp;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.text = [NSString stringWithFormat:@"FPS: %ld", (long)fps];
            
            // 根据 FPS 设置颜色
            if (fps >= 55) {
                self.textColor = [UIColor greenColor];
            } else if (fps >= 45) {
                self.textColor = [UIColor yellowColor];
            } else {
                self.textColor = [UIColor redColor];
            }
        });
    }
}

- (void)dealloc {
    [self stopMonitoring];
}

@end
