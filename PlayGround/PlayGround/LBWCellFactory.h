//
//  LBWCellFactory.h
//  PlayGround
//
//  Created by zjs on 2026/1/27.
//

#import <UIKit/UIKit.h>
#import "LBWModel.h"
#import "LBWCellHeightCache.h"

@class LBWUITableViewCell;

NS_ASSUME_NONNULL_BEGIN

@interface LBWCellFactory : NSObject

/**
 * 注册所有 cell 类型到 tableView
 * @param tableView 需要注册 cell 的 tableView
 */
+ (void)registerCellsForTableView:(UITableView *)tableView;

/**
 * 根据 model 创建对应的 cell
 * @param tableView tableView 实例
 * @param indexPath 索引路径
 * @param model 数据模型
 * @return 配置好的 cell
 */
+ (LBWUITableViewCell *)cellForTableView:(UITableView *)tableView
                              atIndexPath:(NSIndexPath *)indexPath
                                 withModel:(LBWModel *)model;

/**
 * 根据 cellType 获取对应的 reuseIdentifier
 * @param cellType cell 类型
 * @return reuseIdentifier
 */
+ (NSString *)reuseIdentifierForCellType:(CellType)cellType;

/**
 * 根据 model 获取 cell 的高度（带缓存）
 * @param model 数据模型
 * @param indexPath 索引路径
 * @param tableView tableView 实例
 * @return cell 高度
 */
+ (CGFloat)heightForModel:(LBWModel *)model
               atIndexPath:(NSIndexPath *)indexPath
                 tableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
