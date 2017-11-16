//
//  RCTPlayamr.m
//  RCTPlayamr
//
//  Created by Nevo on 14/11/2017.
//  Copyright © 2017 Nevo. All rights reserved.
//


#import <React/RCTLog.h>

#import "RCTPlayamr.h"

@implementation RCTPlayamr
{
    RecordAudio *mRecordAudio;
    RCTResponseSenderBlock mCallback;
}

#define ErrorDomain @"com.nevo.playamr"

typedef NS_ENUM(NSInteger, ErrorFail){
    Error_Code_Open_File_Failed = 1000,
    Error_Code_Play_File_Failed,
};

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(play:(NSString *)name withCallback:(RCTResponseSenderBlock)callback) {
    RCTLogInfo(@"Pretending to play file at %@", name);
    NSData *data = nil;
    
    if ([name hasPrefix:@"http"]) {
        NSURL* url = [NSURL URLWithString:[name stringByRemovingPercentEncoding]];
        data = [NSData dataWithContentsOfURL:url];
    } else {
        data = [NSData dataWithContentsOfFile:name];
    }
    
    if (nil == data) {
        if (callback) {
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"Operation fail", nil),
                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"Can't read file, does file exist?.", nil),
                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Check file path and on again?", nil)
                                       };
            NSError *error = [NSError errorWithDomain:ErrorDomain
                                                 code:Error_Code_Open_File_Failed
                                             userInfo:userInfo];
            callback(@[RCTJSErrorFromNSError(error), @{@"status": @(2)}]);
        }
        return;
    }
    
    if (nil == mRecordAudio) {
        mRecordAudio = [[RecordAudio alloc] init];
        mRecordAudio.delegate = self;
    }
    mCallback = [callback copy];
    [mRecordAudio play:data];
}

RCT_EXPORT_METHOD(stop) {
    if (mRecordAudio) {
        [mRecordAudio stopPlay];
    }
    if (mCallback) {
        [mCallback release];
        mCallback = nil;
    }
}

RCT_EXPORT_METHOD(getAudioTime:(NSString*)name withCallback:(RCTResponseSenderBlock)callback) {
    NSData* data = nil;
    if ([name hasPrefix:@"http"]) {
        NSURL* url = [NSURL URLWithString:[name stringByRemovingPercentEncoding]];
        data = [NSData dataWithContentsOfURL:url];
    } else {
        data = [NSData dataWithContentsOfFile:name];
    }
    NSTimeInterval time = [RecordAudio getAudioTime: data];
    if (callback) {
        callback(@[@(time)]);
    }
}

-(void)RecordStatus:(int)status {
    if (status == 0) {
    } else if(status == 1 || status == 3){
        //完成
        if (mCallback) {
            mCallback(@[[NSNull null], @{@"status": @(status)}]);
            [mCallback release];
            mCallback = nil;
        }
    } else if(status == 2){
        if (mCallback) {
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"Operation fail", nil),
                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"Can't play file, decode file failed?.", nil),
                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Check file and on again?", nil)
                                       };
            NSError *error = [NSError errorWithDomain:ErrorDomain
                                                 code:Error_Code_Play_File_Failed
                                             userInfo:userInfo];
            mCallback(@[RCTJSErrorFromNSError(error), @{@"status": @(2)}]);
            [mCallback release];
            mCallback = nil;
        }
    }
}
@end
