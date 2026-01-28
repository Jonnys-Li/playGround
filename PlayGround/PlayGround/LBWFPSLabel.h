//
//  LBWFPSLabel.h
//  PlayGround
//
//  Created by zjs on 2026/1/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * FPS 性能监控标签
 * 用于实时显示应用的帧率，帮助检测滚动性能
 */
@interface LBWFPSLabel : UILabel

/**
 * 创建并显示 FPS 标签
 * @param view 要添加到哪个视图上（通常添加到 window 或 viewController 的 view）
 */
+ (instancetype)showFPSLabelInView:(UIView *)view;

/**
 * 开始监控
 */
- (void)startMonitoring;

/**
 * 停止监控
 */
- (void)stopMonitoring;

@end

NS_ASSUME_NONNULL_END
