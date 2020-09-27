#include "VinylManager.h"

@implementation VinylManager

+ (instancetype)sharedManager
{
    static VinylManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

@end