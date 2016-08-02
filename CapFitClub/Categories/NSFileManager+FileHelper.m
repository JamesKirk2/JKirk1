//
//  NSFileManager+FileHelper.m
//
//  Created by Sumit Sancheti on 3/24/14.
//  Copyright (c) 2014 Sogeti. All rights reserved.
//

#import "NSFileManager+FileHelper.h"

@implementation NSFileManager (FileHelper)

- (NSString*)documentsDirectoryPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

- (NSString*)cachesDirectoryPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];
    return cacheDirectory;
}

- (NSString*)resourcePath {
    NSString *imagePath = [[NSBundle mainBundle] resourcePath];
    return imagePath;
}

- (NSString*)attachmentsPath {
    NSString* localPath = [self.cachesDirectoryPath stringByAppendingPathComponent:@"Attachments"];
    NSError* error = nil;
    if ([self createDirectoryAtPath:localPath withIntermediateDirectories:YES attributes:nil error:&error]) {
        return localPath;
    }
    return nil;
}

- (NSString*)thumbnailsPath {
    NSString* localPath = [self.cachesDirectoryPath stringByAppendingPathComponent:@"Thumbnails"];
    NSError* error = nil;
    if ([self createDirectoryAtPath:localPath withIntermediateDirectories:YES attributes:nil error:&error]) {
        return localPath;
    }
    return nil;
}

- (NSString*)attachmentFilePath:(NSString*)fileName {
    NSString* attachmentsPath = [self attachmentsPath];
    if (attachmentsPath) {
        return [attachmentsPath stringByAppendingPathComponent:fileName];
    }
    return nil;
}

- (NSString*)thumbnailFilePath:(NSString*)fileName {
    NSString* thumbnailsPath = [self thumbnailsPath];
    if (thumbnailsPath) {
        return [thumbnailsPath stringByAppendingPathComponent:fileName];
    }
    return nil;
}

- (NSString*)temporaryFilePath {
    return [NSString stringWithFormat:@"%@/%@", self.documentsDirectoryPath, @"TemporaryFile.temp"];
}

- (NSString*)lockFilePath {
    return [NSString stringWithFormat:@"%@/%@",self.documentsDirectoryPath,@"lock.txt"];
}

- (void)appendData:(NSData*)data toFileAtPath:(NSString*)destinationPath {
    BOOL isDirectory = NO;
    if([self fileExistsAtPath:destinationPath isDirectory:&isDirectory]) {
        NSError *error = nil;
        [self removeItemAtPath:destinationPath error:&error];
	}
    [self createFileAtPath:destinationPath contents:nil attributes:nil];
	NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:destinationPath];
	[fileHandle seekToEndOfFile];
	[fileHandle writeData:data];
	[fileHandle closeFile];
}

- (BOOL)deleteFileAtPath:(NSString*)filePath {
    BOOL isDirectory = NO;
    if([self fileExistsAtPath:filePath isDirectory:&isDirectory]) {
		return [self removeItemAtPath:filePath error:nil];
	}
    return NO;
}

@end
