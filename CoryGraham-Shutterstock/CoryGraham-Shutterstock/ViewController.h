//
//  ViewController.h
//  CoryGraham-Shutterstock
//
//  Created by Cory Graham on 11/19/13.
//  Copyright (c) 2013 JerremyMasicat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplyFunFiltersViewController.h"
#import "AppDelegate.h"

@interface ViewController : UIViewController<UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

- (IBAction)btnChoosePic:(id)sender;

@end
