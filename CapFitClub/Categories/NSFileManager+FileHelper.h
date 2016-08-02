//
//  NSFileManager+FileHelper.h
//
//  Created by Sumit Sancheti on 3/24/14.
//  Copyright (c) 2014 Sogeti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (FileHelper)

- (NSString*)documentsDirectoryPath;

- (NSString*)cachesDirectoryPath;

- (NSString*)resourcePath;

- (NSString*)attachmentsPath;

- (NSString*)thumbnailsPath;

- (NSString*)thumbnailFilePath:(NSString*)fileName;

- (NSString*)temporaryFilePath;

- (NSString*)lockFilePath;

- (void)appendData:(NSData*)data toFileAtPath:(NSString*)destinationPath;

- (BOOL)deleteFileAtPath:(NSString*)destinationPath;

@end
