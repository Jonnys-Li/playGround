//
//  LBWImagePreloader.h
//  PlayGround
//
//  Created by zjs on 2026/1/27.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 图片预加载管理器
 * 在滚动时预加载即将显示的图片，提升用户体验
 */
@interface LBWImagePreloader : NSObject

/**
 * 单例方法
 */
+ (instancetype)sharedPreloader;

/**
 * 预加载图片
 * @param imageURLs 图片URL数组
 */
- (void)preloadImagesWithURLs:(NSArray<NSString *> *)imageURLs;

/**
 * 预加载单个图片
 * @param imageURL 图片URL
 */
- (void)preloadImageWithURL:(NSString *)imageURL;

/**
 * 根据可见的索引路径预加载附近的图片
 * @param visibleIndexPaths 当前可见的索引路径数组
 * @param totalCount 总数据量
 * @param imageURLBlock 根据索引获取图片URL的block
 * @param preloadCount 预加载的数量（默认前后各3个）
 */
- (void)preloadImagesForVisibleIndexPaths:(NSArray<NSIndexPath *> *)visibleIndexPaths
                                totalCount:(NSInteger)totalCount
                            imageURLBlock:(NSString * _Nullable (^)(NSInteger index))imageURLBlock
                             preloadCount:(NSInteger)preloadCount;

/**
 * 清除预加载队列
 */
- (void)clearPreloadQueue;

@end

NS_ASSUME_NONNULL_END
