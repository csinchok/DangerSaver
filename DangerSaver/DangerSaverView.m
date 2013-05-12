//
//  DangerCacheView.m
//  DangerCache
//
//  Created by Chris Sinchok on 1/7/13.
//  Copyright (c) 2013 Chris Sinchok. All rights reserved.
//

#import "DangerSaverView.h"
#import <CoreServices/CoreServices.h>
#import <Foundation/Foundation.h>
#import <MagicKit/MagicKit.h>

@implementation DangerSaverView
@synthesize webPagePreviews, imageViews, tileSize;

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {        
        
        [self setAnimationTimeInterval:0.05];
        
        imageViews = [[NSMutableArray alloc] initWithCapacity:100];
        
        // 1280x800
        
        int numColumns = 8;
        float tileWidth = frame.size.width / numColumns;
        float tileHeight = tileWidth - (800 % 160);
        
        tileSize = NSMakeSize(tileWidth, tileHeight);
        NSPoint coords = NSMakePoint(0, 0);
        while((coords.y + tileSize.height) <= frame.size.height) {
            while ((coords.x + tileSize.width) <= frame.size.width) {
                NSRect imageRect = NSMakeRect(coords.x, coords.y, tileSize.width, tileSize.height);
                NSImageView *imageView = [[NSImageView alloc] initWithFrame:imageRect];
                [imageView setImageAlignment:NSImageAlignCenter];
                [imageView setImageScaling:NSImageScaleNone];
                [self addSubview:imageView];
                [imageViews addObject:imageView];
                coords = NSMakePoint(coords.x + tileSize.width, coords.y);
            }
            coords = NSMakePoint(0, coords.y + tileSize.height);
        }
    }
    return self;
}

- (NSImage *)getRandomImage
{
    if([webPagePreviews count]) {
        int position = arc4random() % ([webPagePreviews count]);
        NSString *filePath = [webPagePreviews objectAtIndex:position];
        NSImage *image = [[NSImage alloc] initByReferencingFile:filePath];
        [image setScalesWhenResized:YES];
        if ((tileSize.width/tileSize.height) > (image.size.width/image.size.height)) {
            [image setSize:NSMakeSize(tileSize.width, image.size.height * tileSize.width / image.size.width)];
        } else {
            [image setSize:NSMakeSize(image.size.width * tileSize.height / image.size.height, tileSize.height)];
        }
//        [image drawInRect:NSMakeRect(0, 0, tileSize.width, tileSize.height)
//                 fromRect:NSMakeRect(0, 0, tileSize.width, tileSize.height)
//                operation:NSCompositeClear
//                 fraction:1.0];
        return image;
    }
    return nil;
}

- (void)crawlCaches:(NSObject *)obj
{
    // Crawl Safari Caches
    NSError *error = nil;
    NSString *safariPreviewsPath =  [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/com.apple.Safari/Webpage Previews/"];
    NSArray *safariPreviews = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:safariPreviewsPath error:&error];
    
    for(NSString *fileName in safariPreviews) {
        [webPagePreviews addObject:[safariPreviewsPath stringByAppendingString:fileName]];
    }
    
    // Crawl Firefox caches
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
    
    // Crawl Chrome caches
    error = nil;
    NSString *chromeCachePath = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/Google/Chrome/Default/Cache/"];
    NSArray *chromeCaches = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:chromeCachePath error:&error];
    for(NSString *fileName in chromeCaches) {
        NSString *filePath = [chromeCachePath stringByAppendingString:fileName];
        
        GEMagicResult *result = [GEMagicKit magicForFileAtPath:filePath];
        if([result.mimeType hasPrefix:@"image/"]) {
            [webPagePreviews addObject:filePath];
        }
    }
    
}

- (void)startAnimation
{
    webPagePreviews = [[NSMutableArray alloc] initWithCapacity:100];
    
    [self performSelectorInBackground:@selector(crawlCaches:) withObject:nil];
    
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
    int position = arc4random() % ([imageViews count]);
    NSImageView *randomTile = [self.imageViews objectAtIndex:position];
    [randomTile setImage:[self getRandomImage]];
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
