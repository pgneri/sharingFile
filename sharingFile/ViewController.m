//
//  ViewController.m
//  sharingFile
//
//  Created by Stefanini Jaguariúna on 20/10/16.
//  Copyright © 2016 Patrícia Gabriele Neri. All rights reserved.
//

#import "ViewController.h"
#import "NSString+URLEncoding.h"
#import <Foundation/NSException.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)shareAction:(id)sender

 {
         [self cleanupStoredFiles];

        NSString *message   = @"Teste de envio de documento PDF";
        NSString *filename = @"http://www.agipag.com.br/contratos/pdf/politica_privacidade.pdf";
        NSString *urlString = nil;

        NSMutableArray *activityItems = [[NSMutableArray alloc] init];

        if (message != (id)[NSNull null] && message != nil) {
        [activityItems addObject:message];
        }

        if (filename != (id)[NSNull null] && filename != nil) {
          NSObject *file = [self getFile:filename];
          [activityItems addObject:file];
        }

        if (urlString != (id)[NSNull null] && urlString != nil) {
            [activityItems addObject:[NSURL URLWithString:[urlString URLEncodedString]]];
        }

        UIActivity *activity = [[UIActivity alloc] init];
        NSArray *applicationActivities = [[NSArray alloc] initWithObjects:activity, nil];
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:applicationActivities];
        activityViewController.popoverPresentationController.sourceView = self.view;
        [self presentViewController:activityViewController animated:YES completion:nil];

  }

-(UIImage*)getImage: (NSString *)imageName {
  UIImage *image = nil;
  if (imageName != (id)[NSNull null]) {
    if ([imageName hasPrefix:@"http"]) {
      image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageName]]];
    } else if ([imageName hasPrefix:@"www/"]) {
      image = [UIImage imageNamed:imageName];
    } else if ([imageName hasPrefix:@"file://"]) {
      image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[[NSURL URLWithString:imageName] path]]];
    } else if ([imageName hasPrefix:@"data:"]) {
      // using a base64 encoded string
      NSURL *imageURL = [NSURL URLWithString:imageName];
      NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
      image = [UIImage imageWithData:imageData];
    } else if ([imageName hasPrefix:@"assets-library://"]) {
      // use assets-library
      NSURL *imageURL = [NSURL URLWithString:imageName];
      NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
      image = [UIImage imageWithData:imageData];
    } else {
      // assume anywhere else, on the local filesystem
      image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imageName]];
    }
  }
  return image;
}

-(NSURL*)getFile: (NSString *)fileName {
  NSURL *file = nil;
  if (fileName != (id)[NSNull null]) {
    if ([fileName hasPrefix:@"http"]) {
      NSURL *url = [NSURL URLWithString:fileName];
      NSData *fileData = [NSData dataWithContentsOfURL:url];
      NSString *name = (NSString*)[[fileName componentsSeparatedByString: @"/"] lastObject];
      file = [NSURL fileURLWithPath:[self storeInFile:[name componentsSeparatedByString: @"?"][0] fileData:fileData]];
    } else if ([fileName hasPrefix:@"www/"]) {
      NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
      NSString *fullPath = [NSString stringWithFormat:@"%@/%@", bundlePath, fileName];
      file = [NSURL fileURLWithPath:fullPath];
    } else if ([fileName hasPrefix:@"file://"]) {
      // stripping the first 6 chars, because the path should start with / instead of file://
      file = [NSURL fileURLWithPath:[fileName substringFromIndex:6]];
    } else if ([fileName hasPrefix:@"data:"]) {
      // using a base64 encoded string
      // extract some info from the 'fileName', which is for example: data:text/calendar;base64,<encoded stuff here>
      NSString *fileType = (NSString*)[[[fileName substringFromIndex:5] componentsSeparatedByString: @";"] objectAtIndex:0];
      fileType = (NSString*)[[fileType componentsSeparatedByString: @"/"] lastObject];
      NSString *base64content = (NSString*)[[fileName componentsSeparatedByString: @","] lastObject];
      NSData *fileData = [ViewController dataFromBase64String:base64content];
      file = [NSURL fileURLWithPath:[self storeInFile:[NSString stringWithFormat:@"%@.%@", @"file", fileType] fileData:fileData]];
    } else {
      // assume anywhere else, on the local filesystem
      file = [NSURL fileURLWithPath:fileName];
    }
  }
  return file;
}

+ (NSData*) dataFromBase64String:(NSString*)aString {
  return [[NSData alloc] initWithBase64EncodedString:aString options:0];
}


-(NSString*) storeInFile: (NSString*) fileName
                fileData: (NSData*) fileData {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
  [fileData writeToFile:filePath atomically:YES];
  _tempStoredFile = filePath;
  return filePath;
}

- (void) cleanupStoredFiles {
  if (_tempStoredFile != nil) {
    NSError *error;
    [[NSFileManager defaultManager]removeItemAtPath:_tempStoredFile error:&error];
  }
}



@end
