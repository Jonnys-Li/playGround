//
//  LBWCellHeightCache.h
//  PlayGround
//
//  Created by zjs on 2026/1/27.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LBWModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Cell 高度缓存管理器
 * 支持动态高度计算和缓存，提升滚动性能
 */
@interface LBWCellHeightCache : NSObject

/**
 * 单例方法
 */
+ (instancetype)sharedCache;

/**
 * 获取缓存的高度
 * @param indexPath cell 的索引路径
 * @return 缓存的高度，如果不存在则返回 UITableViewAutomaticDimension
 */
- (CGFloat)cachedHeightForIndexPath:(NSIndexPath *)indexPath;

/**
 * 缓存 cell 高度
 * @param height 高度值
 * @param indexPath cell 的索引路径
 */
- (void)cacheHeight:(CGFloat)height forIndexPath:(NSIndexPath *)indexPath;

/**
 * 根据 model 计算并缓存 cell 高度
 * @param model 数据模型
 * @param indexPath 索引路径
 * @param tableView tableView 实例（用于获取宽度）
 * @return 计算后的高度
 */
- (CGFloat)calculateAndCacheHeightForModel:(LBWModel *)model
                                atIndexPath:(NSIndexPath *)indexPath
                                  tableView:(UITableView *)tableView;

/**
 * 清除所有缓存
 */
- (void)clearCache;

/**
 * 清除指定索引路径的缓存
 * @param indexPath 索引路径
 */
- (void)clearCacheForIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
