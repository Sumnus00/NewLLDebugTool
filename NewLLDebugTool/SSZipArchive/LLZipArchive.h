//
//  LLZipArchive.h
//  LLZipArchive
//
//  Created by Sam Soffes on 7/21/10.
//  Copyright (c) Sam Soffes 2010-2015. All rights reserved.
//

#ifndef _LLZIPARCHIVE_H
#define _LLZIPARCHIVE_H

#import <Foundation/Foundation.h>
#include "LLZipCommon.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const LLZipArchiveErrorDomain;
typedef NS_ENUM(NSInteger, LLZipArchiveErrorCode) {
    LLZipArchiveErrorCodeFailedOpenZipFile      = -1,
    LLZipArchiveErrorCodeFailedOpenFileInZip    = -2,
    LLZipArchiveErrorCodeFileInfoNotLoadable    = -3,
    LLZipArchiveErrorCodeFileContentNotReadable = -4,
    LLZipArchiveErrorCodeFailedToWriteFile      = -5,
    LLZipArchiveErrorCodeInvalidArguments       = -6,
};

@protocol LLZipArchiveDelegate;

@interface LLZipArchive : NSObject

// Password check
+ (BOOL)isFilePasswordProtectedAtPath:(NSString *)path;
+ (BOOL)isPasswordValidForArchiveAtPath:(NSString *)path password:(NSString *)pw error:(NSError * _Nullable * _Nullable)error NS_SWIFT_NOTHROW;

// Unzip
+ (BOOL)unzipFileAtPath:(NSString *)path toDestination:(NSString *)destination;
+ (BOOL)unzipFileAtPath:(NSString *)path toDestination:(NSString *)destination delegate:(nullable id<LLZipArchiveDelegate>)delegate;

+ (BOOL)unzipFileAtPath:(NSString *)path
          toDestination:(NSString *)destination
              overwrite:(BOOL)overwrite
               password:(nullable NSString *)password
                  error:(NSError * *)error;

+ (BOOL)unzipFileAtPath:(NSString *)path
          toDestination:(NSString *)destination
              overwrite:(BOOL)overwrite
               password:(nullable NSString *)password
                  error:(NSError * *)error
               delegate:(nullable id<LLZipArchiveDelegate>)delegate NS_REFINED_FOR_SWIFT;

+ (BOOL)unzipFileAtPath:(NSString *)path
          toDestination:(NSString *)destination
     preserveAttributes:(BOOL)preserveAttributes
              overwrite:(BOOL)overwrite
               password:(nullable NSString *)password
                  error:(NSError * *)error
               delegate:(nullable id<LLZipArchiveDelegate>)delegate;

+ (BOOL)unzipFileAtPath:(NSString *)path
          toDestination:(NSString *)destination
        progressHandler:(void (^_Nullable)(NSString *entry, unz_file_info zipInfo, long entryNumber, long total))progressHandler
      completionHandler:(void (^_Nullable)(NSString *path, BOOL succeeded, NSError * _Nullable error))completionHandler;

+ (BOOL)unzipFileAtPath:(NSString *)path
          toDestination:(NSString *)destination
              overwrite:(BOOL)overwrite
               password:(nullable NSString *)password
        progressHandler:(void (^_Nullable)(NSString *entry, unz_file_info zipInfo, long entryNumber, long total))progressHandler
      completionHandler:(void (^_Nullable)(NSString *path, BOOL succeeded, NSError * _Nullable error))completionHandler;

+ (BOOL)unzipFileAtPath:(NSString *)path
          toDestination:(NSString *)destination
     preserveAttributes:(BOOL)preserveAttributes
              overwrite:(BOOL)overwrite
         nestedZipLevel:(NSInteger)nestedZipLevel
               password:(nullable NSString *)password
                  error:(NSError **)error
               delegate:(nullable id<LLZipArchiveDelegate>)delegate
        progressHandler:(void (^_Nullable)(NSString *entry, unz_file_info zipInfo, long entryNumber, long total))progressHandler
      completionHandler:(void (^_Nullable)(NSString *path, BOOL succeeded, NSError * _Nullable error))completionHandler;

// Zip
// default compression level is Z_DEFAULT_COMPRESSION (from "zlib.h")

// without password
+ (BOOL)createZipFileAtPath:(NSString *)path withFilesAtPaths:(NSArray<NSString *> *)paths;
+ (BOOL)createZipFileAtPath:(NSString *)path withContentsOfDirectory:(NSString *)directoryPath;

+ (BOOL)createZipFileAtPath:(NSString *)path withContentsOfDirectory:(NSString *)directoryPath keepParentDirectory:(BOOL)keepParentDirectory;

// with optional password, default encryption is AES
// don't use AES if you need compatibility with native macOS unzip and Archive Utility
+ (BOOL)createZipFileAtPath:(NSString *)path withFilesAtPaths:(NSArray<NSString *> *)paths withPassword:(nullable NSString *)password;
+ (BOOL)createZipFileAtPath:(NSString *)path withContentsOfDirectory:(NSString *)directoryPath withPassword:(nullable NSString *)password;
+ (BOOL)createZipFileAtPath:(NSString *)path withContentsOfDirectory:(NSString *)directoryPath keepParentDirectory:(BOOL)keepParentDirectory withPassword:(nullable NSString *)password;
+ (BOOL)createZipFileAtPath:(NSString *)path
    withContentsOfDirectory:(NSString *)directoryPath
        keepParentDirectory:(BOOL)keepParentDirectory
               withPassword:(nullable NSString *)password
         andProgressHandler:(void(^ _Nullable)(NSUInteger entryNumber, NSUInteger total))progressHandler;
+ (BOOL)createZipFileAtPath:(NSString *)path
    withContentsOfDirectory:(NSString *)directoryPath
        keepParentDirectory:(BOOL)keepParentDirectory
           compressionLevel:(int)compressionLevel
                   password:(nullable NSString *)password
                        AES:(BOOL)aes
            progressHandler:(void(^ _Nullable)(NSUInteger entryNumber, NSUInteger total))progressHandler;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithPath:(NSString *)path NS_DESIGNATED_INITIALIZER;
- (BOOL)open;

/// write empty folder
- (BOOL)writeFolderAtPath:(NSString *)path withFolderName:(NSString *)folderName withPassword:(nullable NSString *)password;
/// write file
- (BOOL)writeFile:(NSString *)path withPassword:(nullable NSString *)password;
- (BOOL)writeFileAtPath:(NSString *)path withFileName:(nullable NSString *)fileName withPassword:(nullable NSString *)password;
- (BOOL)writeFileAtPath:(NSString *)path withFileName:(nullable NSString *)fileName compressionLevel:(int)compressionLevel password:(nullable NSString *)password AES:(BOOL)aes;
/// write data
- (BOOL)writeData:(NSData *)data filename:(nullable NSString *)filename withPassword:(nullable NSString *)password;
- (BOOL)writeData:(NSData *)data filename:(nullable NSString *)filename compressionLevel:(int)compressionLevel password:(nullable NSString *)password AES:(BOOL)aes;

- (BOOL)close;

@end

@protocol LLZipArchiveDelegate <NSObject>

@optional

- (void)zipArchiveWillUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo;
- (void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo unzippedPath:(NSString *)unzippedPath;

- (BOOL)zipArchiveShouldUnzipFileAtIndex:(NSInteger)fileIndex totalFiles:(NSInteger)totalFiles archivePath:(NSString *)archivePath fileInfo:(unz_file_info)fileInfo;
- (void)zipArchiveWillUnzipFileAtIndex:(NSInteger)fileIndex totalFiles:(NSInteger)totalFiles archivePath:(NSString *)archivePath fileInfo:(unz_file_info)fileInfo;
- (void)zipArchiveDidUnzipFileAtIndex:(NSInteger)fileIndex totalFiles:(NSInteger)totalFiles archivePath:(NSString *)archivePath fileInfo:(unz_file_info)fileInfo;
- (void)zipArchiveDidUnzipFileAtIndex:(NSInteger)fileIndex totalFiles:(NSInteger)totalFiles archivePath:(NSString *)archivePath unzippedFilePath:(NSString *)unzippedFilePath;

- (void)zipArchiveProgressEvent:(unsigned long long)loaded total:(unsigned long long)total;

@end

NS_ASSUME_NONNULL_END

#endif /* _LLZIPARCHIVE_H */
