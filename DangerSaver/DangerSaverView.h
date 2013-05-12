//
//  DangerCacheView.h
//  DangerCache
//
//  Created by Chris Sinchok on 1/7/13.
//  Copyright (c) 2013 Chris Sinchok. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>

@interface DangerSaverView : ScreenSaverView {
    NSMutableArray *webPagePreviews;
    NSMutableArray *imageViews;
    NSSize tileSize;
}

@property (nonatomic, retain) NSMutableArray *imageViews;
@property (nonatomic, retain) NSMutableArray *webPagePreviews;
@property (nonatomic) NSSize tileSize;


- (NSImage *)getRandomImage;
- (void)crawlCaches:(NSObject *)obj;

@end
