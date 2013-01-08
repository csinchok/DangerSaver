//
//  DangerCacheView.m
//  DangerCache
//
//  Created by Chris Sinchok on 1/7/13.
//  Copyright (c) 2013 Chris Sinchok. All rights reserved.
//

#import "DangerSaverView.h"

@implementation DangerSaverView
@synthesize imageView, webPagePreviews;

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        [self setAnimationTimeInterval:1];
        self.imageView = [[NSImageView alloc] initWithFrame:[self bounds]];
        [self addSubview:self.imageView];
    }
    return self;
}

- (NSImage *)getRandomImage
{
    if([webPagePreviews count]) {
        int position = arc4random() % ([webPagePreviews count]);
        NSString *filePath = [webPagePreviews objectAtIndex:position];
        NSLog(@"Random image: %@", filePath);
        return [[NSImage alloc] initByReferencingFile:filePath];
    }
    return nil;
}

- (void)startAnimation
{
    webPagePreviews = [[NSMutableArray alloc] initWithCapacity:100];
    
    NSError *error = nil;
    NSString *safariPreviewsPath =  [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/com.apple.Safari/Webpage Previews/"];
    NSArray *safariPreviews = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:safariPreviewsPath error:&error];
    
    for(NSString *fileName in safariPreviews) {
        [webPagePreviews addObject:[safariPreviewsPath stringByAppendingString:fileName]];
    }
    
    error = nil;
    NSString *firefoxProfilesPath = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/Firefox/Profiles/"];
    NSArray *profiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:firefoxProfilesPath error:&error];
    for(NSString *profileName in profiles) {
        NSString *firefoxPreviewsPath = [firefoxProfilesPath stringByAppendingFormat:@"%@/thumbnails/", profileName];
        NSArray *firefoxPreviews = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:firefoxPreviewsPath error:&error];
        for(NSString *fileName in firefoxPreviews) {
            [webPagePreviews addObject:[firefoxPreviewsPath stringByAppendingString:fileName]];
        }
    }
    
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
}

- (void)animateOneFrame
{
    NSLog(@"Setting image...");
    [self.imageView setImage:[self getRandomImage]];
    return;
}

- (BOOL)hasConfigureSheet
{
    return NO;
}

- (NSWindow*)configureSheet
{
    return nil;
}

@end
