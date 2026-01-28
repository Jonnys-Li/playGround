//
//  LBWCellFactory.m
//  PlayGround
//
//  Created by zjs on 2026/1/27.
//

#import "LBWCellFactory.h"
#import "LBWUITableViewCell.h"
#import "LBWCellHeightCache.h"

@implementation LBWCellFactory

+ (void)registerCellsForTableView:(UITableView *)tableView {
    // 注册所有类型的 cell
    [tableView registerClass:[LBWUITableViewCell class] 
      forCellReuseIdentifier:[self reuseIdentifierForCellType:CellTypePlain]];
    [tableView registerClass:[LBWUITableViewCell class] 
      forCellReuseIdentifier:[self reuseIdentifierForCellType:CellTypeImg]];
    [tableView registerClass:[LBWUITableViewCell class] 
      forCellReuseIdentifier:[self reuseIdentifierForCellType:CellTypeLong]];
    
}

+ (LBWUITableViewCell *)cellForTableView:(UITableView *)tableView
                              atIndexPath:(NSIndexPath *)indexPath
                                 withModel:(LBWModel *)model {
    NSString *reuseIdentifier = [self reuseIdentifierForCellType:model.celltype];
    LBWUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier 
                                                                 forIndexPath:indexPath];
    [cell configWithModel:model];
    return cell;
}


+ (NSString *)reuseIdentifierForCellType:(CellType)cellType {
    switch (cellType) {
        case CellTypePlain:
            return @"LBWPlainCellID";
        case CellTypeImg:
            return @"LBWImageCellID";
        case CellTypeLong:
            return @"LBWLongCellID";
        default:
            return @"LBWPlainCellID";
    }
}

+ (CGFloat)heightForModel:(LBWModel *)model
               atIndexPath:(NSIndexPath *)indexPath
                 tableView:(UITableView *)tableView {
    // 使用高度缓存管理器获取或计算高度
    LBWCellHeightCache *cache = [LBWCellHeightCache sharedCache];
    return [cache calculateAndCacheHeightForModel:model atIndexPath:indexPath tableView:tableView];
}

@end
