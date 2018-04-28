//
//  NetworkCache.m
//  MSBCooperate
//
//  Created by xtxk on 15/7/17.
//  Copyright (c) 2015年 xtxk1. All rights reserved.
//

#import "NetworkCache.h"

#define kMenuStaleSeconds 60*3

@interface NetworkCache()
+(NSString*) cacheDirectory;
+(NSString*) appVersion;

@end

static NSMutableDictionary *memoryCache;
static NSMutableArray *recentlyAccessedKeys;
static int kCacheMemoryLimit;

@implementation NetworkCache

+(void)initialize
{
    NSString *cacheDirectory = [NetworkCache cacheDirectory];
    if (![[NSFileManager defaultManager] fileExistsAtPath:cacheDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cacheDirectory
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    double lastSavedCacheVersion = [[NSUserDefaults standardUserDefaults] doubleForKey:@"CACHE_VERSION"];
    double currentAppVersion = [[NetworkCache appVersion] doubleValue];
    if (lastSavedCacheVersion == 0.0f || lastSavedCacheVersion < currentAppVersion) {
        [NetworkCache clearCache];
        [[NSUserDefaults standardUserDefaults] setDouble:currentAppVersion forKey:@"CACHE_VERSION"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    memoryCache = [[NSMutableDictionary alloc] init];
    recentlyAccessedKeys = [[NSMutableArray alloc] init];
    kCacheMemoryLimit = 10;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveMemoryCacheToDisk:)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveMemoryCacheToDisk:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveMemoryCacheToDisk:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
}


+(void) dealloc
{
    memoryCache = nil;
    
    recentlyAccessedKeys = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
    
}

+(void)saveMemoryCacheToDisk:(NSNotification*)notification
{
    for (NSString *filename in [memoryCache allKeys]) {
        NSString *archivePath = [[NetworkCache cacheDirectory] stringByAppendingPathComponent:filename];
        NSData *cacheData = [memoryCache objectForKey:filename];
        [cacheData writeToFile:archivePath atomically:YES];
    }
    [memoryCache removeAllObjects];
}

+(void)clearCache
{
    NSArray *cacheItems = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NetworkCache cacheDirectory] error:nil];
    for (NSString *path in cacheItems) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    [memoryCache removeAllObjects];
}

+(NSString*)appVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
}

+(NSString *)cacheDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    return [cachesDirectory stringByAppendingPathComponent:@"AppCache"];
}


+(void) cacheData:(NSData*) data toFile:(NSString*) fileName
{
    [memoryCache setObject:data forKey:fileName];
    if([recentlyAccessedKeys containsObject:fileName])
    {
        [recentlyAccessedKeys removeObject:fileName];
    }
    
    [recentlyAccessedKeys insertObject:fileName atIndex:0];
    
    if([recentlyAccessedKeys count] > kCacheMemoryLimit)
    {
        NSString *leastRecentlyUsedDataFilename = [recentlyAccessedKeys lastObject];
        NSData *leastRecentlyUsedCacheData = [memoryCache objectForKey:leastRecentlyUsedDataFilename];
        NSString *archivePath = [[NetworkCache cacheDirectory] stringByAppendingPathComponent:fileName];
        [leastRecentlyUsedCacheData writeToFile:archivePath atomically:YES];
        
        [recentlyAccessedKeys removeLastObject];
        [memoryCache removeObjectForKey:leastRecentlyUsedDataFilename];
    }
}

+(NSData*) dataForFile:(NSString*) fileName
{
    NSData *data = [memoryCache objectForKey:fileName];
    if(data) return data; // data is present in memory cache
    
    NSString *archivePath = [[NetworkCache cacheDirectory] stringByAppendingPathComponent:fileName];
    data = [NSData dataWithContentsOfFile:archivePath];
    
    if(data)
        [self cacheData:data toFile:fileName]; // put the recently accessed data to memory cache
    
    return data;
}

+(void)cacheJsonResponse:(RespBase *)json withName:(NSString *)fileName
{
    [self cacheData:[NSKeyedArchiver archivedDataWithRootObject:json] toFile:fileName];
}

+(RespBase *)getJsonCacheWithName:(NSString *)filename
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[self dataForFile:filename]];
}

+(BOOL)isJsonStaleWithName:(NSString *)filename
{
    if ([recentlyAccessedKeys containsObject:filename]) {
        return NO;
    }
    NSString *archivePath = [[NetworkCache cacheDirectory] stringByAppendingPathComponent:filename];
    NSTimeInterval stalenessLevel = [[[[NSFileManager defaultManager] attributesOfItemAtPath:archivePath error:nil] fileModificationDate] timeIntervalSinceNow];
    return fabs( stalenessLevel) > kMenuStaleSeconds;
}

@end
