//
//  DangerCacheView.h
//  DangerCache
//
//  Created by Chris Sinchok on 1/7/13.
//  Copyright (c) 2013 Chris Sinchok. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>

@interface DangerSaverView : ScreenSaverView {
    NSImageView *imageView;
    NSMutableArray *webPagePreviews;
}

@property (nonatomic, retain) NSImageView *imageView;
@property (nonatomic, retain) NSMutableArray *webPagePreviews;


- (NSImage *)getRandomImage;

@end
