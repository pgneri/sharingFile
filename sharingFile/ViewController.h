//
//  ViewController.h
//  sharingFile
//
//  Created by Stefanini Jaguariúna on 20/10/16.
//  Copyright © 2016 Patrícia Gabriele Neri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface ViewController : UIViewController <UIPopoverControllerDelegate, MFMailComposeViewControllerDelegate, UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) MFMailComposeViewController *globalMailComposer;
@property (nonatomic, strong) UIDocumentInteractionController * documentInteractionController;
@property (retain) NSString * tempStoredFile;


@end

