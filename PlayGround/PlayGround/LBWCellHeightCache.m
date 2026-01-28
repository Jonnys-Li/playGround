//
//  LBWCellHeightCache.m
//  PlayGround
//
//  Created by zjs on 2026/1/27.
//

#import "LBWCellHeightCache.h"
#import "LBWUITableViewCell.h"

static NSString * const kHeightCacheKeyFormat = @"%ld-%ld";

@implementation LBWCellHeightCache {
    NSMutableDictionary<NSString *, NSNumber *> *_heightCache;
}

+ (instancetype)sharedCache {
    static LBWCellHeightCache *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LBWCellHeightCache alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _heightCache = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSString *)cacheKeyForIndexPath:(NSIndexPath *)indexPath {
    return [NSString stringWithFormat:kHeightCacheKeyFormat, (long)indexPath.section, (long)indexPath.row];
}

- (CGFloat)cachedHeightForIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [self cacheKeyForIndexPath:indexPath];
    NSNumber *cachedHeight = _heightCache[key];
    if (cachedHeight) {
        return [cachedHeight floatValue];
    }
    return UITableViewAutomaticDimension;
}

- (void)cacheHeight:(CGFloat)height forIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [self cacheKeyForIndexPath:indexPath];
    _heightCache[key] = @(height);
}

- (CGFloat)calculateAndCacheHeightForModel:(LBWModel *)model
                                atIndexPath:(NSIndexPath *)indexPath
                                  tableView:(UITableView *)tableView {
    // 先检查缓存
    CGFloat cachedHeight = [self cachedHeightForIndexPath:indexPath];
    if (cachedHeight != UITableViewAutomaticDimension) {
        return cachedHeight;
    }
    
    // 如果没有缓存，则计算高度
    CGFloat calculatedHeight = [self calculateHeightForModel:model tableView:tableView];
    
    // 缓存计算结果
    [self cacheHeight:calculatedHeight forIndexPath:indexPath];
    
    return calculatedHeight;
}

- (CGFloat)calculateHeightForModel:(LBWModel *)model tableView:(UITableView *)tableView {
    // 使用系统默认高度作为基础
    CGFloat baseHeight = 0;
    
    switch (model.celltype) {
        case CellTypePlain:
            baseHeight = 80.0;
            break;
        case CellTypeImg:
            baseHeight = 200.0;
            break;
        case CellTypeLong:
            baseHeight = 150.0;
            break;
        default:
            baseHeight = 80.0;
            break;
    }
    
    // 如果内容较长，需要动态计算
    if (model.content.length > 0) {
        CGFloat contentWidth = tableView.bounds.size.width - 20 - 80 - 30; // 减去左右边距和图片宽度
        if (model.celltype == CellTypePlain) {
            contentWidth = tableView.bounds.size.width - 20; // Plain类型没有图片
        }
        
        NSDictionary *attributes = @{
            NSFontAttributeName: [UIFont systemFontOfSize:14]
        };
        CGRect contentRect = [model.content boundingRectWithSize:CGSizeMake(contentWidth, CGFLOAT_MAX)
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:attributes
                                                         context:nil];
        
        CGFloat contentHeight = ceil(contentRect.size.height);
        CGFloat titleHeight = 20; // 标题高度
        CGFloat spacing = 20; // 上下间距
        
        CGFloat dynamicHeight = titleHeight + contentHeight + spacing;
        
        // 取较大值，但不超过基础高度的2倍
        baseHeight = MAX(baseHeight, MIN(dynamicHeight, baseHeight * 2));
    }
    
    return baseHeight;
}

- (void)clearCache {
    [_heightCache removeAllObjects];
}

- (void)clearCacheForIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [self cacheKeyForIndexPath:indexPath];
    [_heightCache removeObjectForKey:key];
}

@end
