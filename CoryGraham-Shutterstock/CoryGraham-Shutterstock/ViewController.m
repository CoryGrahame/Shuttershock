//
//  ViewController.m
//  CoryGraham-Shutterstock
//
//  Created by Cory Graham on 11/19/13.
//  Copyright (c) 2013 JerremyMasicat. All rights reserved.
//

/*
    Wrangled this up in two hours, lots of room for improvement. Essentially would want to support just about every filter in the end; some filters take no arguments, some 1, 2, 3, etc. apart from other unique steps. Enjoy!
*/

#import "ViewController.h"

@interface ViewController ()

{
    ApplyFunFiltersViewController *funFilterVC;
}

@end


@implementation ViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationItem setTitle:@"!Dynamite Pictures!"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    funFilterVC= (ApplyFunFiltersViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"ApplyFunFiltersViewController"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnChoosePic:(id)sender
{
    UIActionSheet *picFromWhere = [[UIActionSheet alloc] initWithTitle:@"Start your dynamite adventure!" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take picture", @"From library", @"Default image", nil];
    [picFromWhere showInView:self.view.superview];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0: //use camera to capture an image
        {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                      message:@"Device has no camera"
                                                                     delegate:nil
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles: nil];
                [myAlertView show];
            }
            else
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.allowsEditing = YES;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:picker animated:YES completion:NULL];
            }
        }
            break;
        case 1: // browse existing pictures for an imgage
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:NULL];
        }
            break;
        case 2: // proceed with default image
        {
            AppDelegate *del = (AppDelegate*)[UIApplication sharedApplication].delegate;
            del.imgToMod = [UIImage imageNamed:@"ninja-dinosaur.jpg"];
            [self.navigationController pushViewController:funFilterVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

////UIImagePicker methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    AppDelegate *del = (AppDelegate*)[UIApplication sharedApplication].delegate;
    del.imgToMod = info[UIImagePickerControllerEditedImage];
    [self.navigationController pushViewController:funFilterVC animated:YES];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
