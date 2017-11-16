//
//  RCTPlayamr.h
//  RCTPlayamr
//
//  Created by Nevo on 14/11/2017.
//  Copyright © 2017 Nevo. All rights reserved.
//

#import <Foundation/Foundation.h>
#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif
#import "RecordAudio.h"

@interface RCTPlayamr : NSObject<RCTBridgeModule, RecordAudioDelegate>


@end
