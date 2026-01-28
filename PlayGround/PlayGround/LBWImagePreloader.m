//
//  LBWImagePreloader.m
//  PlayGround
//
//  Created by zjs on 2026/1/27.
//

#import "LBWImagePreloader.h"
#import <SDWebImage/SDWebImage.h>

@implementation LBWImagePreloader {
    NSMutableSet<NSString *> *_preloadingURLs;
    dispatch_queue_t _preloadQueue;
}

+ (instancetype)sharedPreloader {
    static LBWImagePreloader *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LBWImagePreloader alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _preloadingURLs = [NSMutableSet set];
        _preloadQueue = dispatch_queue_create("com.lbw.imagepreloader", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)preloadImagesWithURLs:(NSArray<NSString *> *)imageURLs {
    if (imageURLs.count == 0) {
        return;
    }
    
    dispatch_async(_preloadQueue, ^{
        for (NSString *urlString in imageURLs) {
            if (urlString.length > 0 && ![self->_preloadingURLs containsObject:urlString]) {
                [self preloadImageWithURL:urlString];
            }
        }
    });
}

- (void)preloadImageWithURL:(NSString *)imageURL {
    if (imageURL.length == 0) {
        return;
    }
    
    // 检查是否已经在预加载
    @synchronized (_preloadingURLs) {
        if ([_preloadingURLs containsObject:imageURL]) {
            return;
        }
        [_preloadingURLs addObject:imageURL];
    }
    
    NSURL *url = [NSURL URLWithString:imageURL];
    if (!url) {
        @synchronized (_preloadingURLs) {
            [_preloadingURLs removeObject:imageURL];
        }
        return;
    }
    
    // 使用 SDWebImage 预加载
    [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:@[url] progress:nil completed:^(NSUInteger noOfFinishedUrls, NSUInteger noOfSkippedUrls) {
        @synchronized (self->_preloadingURLs) {
            [self->_preloadingURLs removeObject:imageURL];
        }
    }];
}

- (void)preloadImagesForVisibleIndexPaths:(NSArray<NSIndexPath *> *)visibleIndexPaths
                                totalCount:(NSInteger)totalCount
                            imageURLBlock:(NSString * _Nullable (^)(NSInteger))imageURLBlock
                             preloadCount:(NSInteger)preloadCount {
    if (visibleIndexPaths.count == 0 || !imageURLBlock) {
        return;
    }
    
    // 找到最小和最大的可见索引
    NSInteger minIndex = NSIntegerMax;
    NSInteger maxIndex = NSIntegerMin;
    
    for (NSIndexPath *indexPath in visibleIndexPaths) {
        NSInteger index = indexPath.row;
        minIndex = MIN(minIndex, index);
        maxIndex = MAX(maxIndex, index);
    }
    
    // 计算预加载范围
    NSInteger startIndex = MAX(0, minIndex - preloadCount);
    NSInteger endIndex = MIN(totalCount - 1, maxIndex + preloadCount);
    
    // 收集需要预加载的URL
    NSMutableArray<NSString *> *urlsToPreload = [NSMutableArray array];
    
    for (NSInteger i = startIndex; i <= endIndex; i++) {
        // 跳过已经可见的范围
        if (i >= minIndex && i <= maxIndex) {
            continue;
        }
        
        NSString *imageURL = imageURLBlock(i);
        if (imageURL && imageURL.length > 0) {
            [urlsToPreload addObject:imageURL];
        }
    }
    
    // 执行预加载
    if (urlsToPreload.count > 0) {
        [self preloadImagesWithURLs:urlsToPreload];
    }
}

- (void)clearPreloadQueue {
    @synchronized (_preloadingURLs) {
        [_preloadingURLs removeAllObjects];
    }
    [[SDWebImagePrefetcher sharedImagePrefetcher] cancelPrefetching];
}

@end
