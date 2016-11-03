//
//  CURLDataDownloader.m
//  QQStock
//
//  Created by suning wang on 12-7-24.
//  Copyright (c) 2012年 tencent. All rights reserved.
//

#import "CURLDataDownloader.h"

@interface CURLDataLoader ()

- (void) startTimeoutTimer;
- (void) cancelLoadData;

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end

@interface CURLDataDownloader ()

@property (nonatomic,retain) NSFileHandle* fileHandle;

- (void) resetFileHandleAtPath:(NSString*)path;

@end

@implementation CURLDataDownloader
@synthesize fileHandle = _fileHandle;
@synthesize localPath = _localPath;

- (void) resetFileHandleAtPath:(NSString*)path
{
	if (path != nil)
	{
		NSFileManager* tFileManager = [NSFileManager defaultManager];
		if ([tFileManager fileExistsAtPath:path])
		{
			[tFileManager removeItemAtPath:path error:nil];
		}
		[tFileManager createFileAtPath:path contents:nil attributes:nil];
		
		self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
	}
	else 
	{
		self.fileHandle = nil;
	}
}

- (void) cancelLoadData
{
	[self resetFileHandleAtPath:nil];
	[super cancelLoadData];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[self resetFileHandleAtPath:self.localPath];
	[super connection:connection didReceiveResponse:response];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	if (self.urlConnection == nil) return;
	
	[self.fileHandle writeData:data];
	[self startTimeoutTimer];
	
	if ([self.delegate respondsToSelector:@selector(urlDataLoadProgress:progress:)])
	{
		float progress = 0.0f;
		if (_contentLength > 0.0f)
		{
			progress = [self.fileHandle offsetInFile] * 1.0f / _contentLength;
		}
		[self.delegate urlDataLoadProgress:self progress:progress];
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[self resetFileHandleAtPath:nil];
	[super connection:connection didFailWithError:error];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection 
{
	[self resetFileHandleAtPath:nil];
	[super connectionDidFinishLoading:connection];
}

- (void) dealloc
{
	[self resetFileHandleAtPath:nil];
	
}

@end
