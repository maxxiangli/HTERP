

#import "CHFileManager.h"

@interface CHFileManager()
- (void)makeDirectoryExist:(NSString *)path;
- (void)copyItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath;

@end

@implementation CHFileManager

@synthesize documentDirectory = documentDirectory_;
@synthesize rootDirectory = rootDirectory_;

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if ([documentDirectories count] > 0)
        {
            self.documentDirectory = [documentDirectories objectAtIndex:0];
        }

        self.rootDirectory = [self.documentDirectory stringByAppendingString:@"/Chahua_Resources/"];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createDirectoryAtPath:self.rootDirectory
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
        

    }
    return self;
}

//----------------------------------------------------------
#pragma mark Singleton interface

static CHFileManager *defaultFileManager_ = nil;

+ (CHFileManager *)defaultManager {
    @synchronized (self) {
        if (defaultFileManager_ == nil) {
            defaultFileManager_ = [[self alloc] init];
        }
        
        return defaultFileManager_;
    }
}

- (void)makeDirectoryExist:(NSString *)path {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (void)copyItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dstPath]) {
        [fileManager copyItemAtPath:srcPath toPath:dstPath error:nil];
    }
}

@end
