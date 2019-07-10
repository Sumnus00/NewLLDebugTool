//
//  MockViewController.m
//  LLDebugToolDemo
//
//  Created by apple on 2019/7/9.
//  Copyright © 2019 li. All rights reserved.
//

#import "MockViewController.h"
#import "OHHTTPStubs.h"
#import "OHPathHelpers.h"

@interface MockViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *delaySwitch;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UISwitch *installTextStubSwitch;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISwitch *installImageStubSwitch;

@end

@implementation MockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:NO] ;
//    [self installTextStub:self.installTextStubSwitch];
//    [self installImageStub:self.installImageStubSwitch];
    self.installTextStubSwitch.enabled = false ;
    self.installImageStubSwitch.enabled = false ;
    self.delaySwitch.enabled = false ;
    [OHHTTPStubs onStubActivation:^(NSURLRequest * _Nonnull request, id<OHHTTPStubsDescriptor>  _Nonnull stub, OHHTTPStubsResponse * _Nonnull responseStub) {
        NSLog(@"[OHHTTPStubs] Request to %@ has been stubbed with %@", request.URL, stub.name);
    }];
}

- (BOOL)shouldUseDelay {
    __block BOOL res = NO;
    dispatch_sync(dispatch_get_main_queue(), ^{
        res = self.delaySwitch.on;
    });
    return res;
}

- (IBAction)toggleStubs:(UISwitch *)sender {
    [OHHTTPStubs setEnabled:sender.on];
    self.delaySwitch.enabled = sender.on;
    self.installTextStubSwitch.enabled = sender.on;
    self.installImageStubSwitch.enabled = sender.on;
    
    NSLog(@"Installed (%@) stubs: %@", (sender.on?@"and enabled":@"but disabled"), OHHTTPStubs.allStubs);
    
}
- (IBAction)downloadText:(UIButton *)sender {
    sender.enabled = NO;
    self.textView.text = nil;
    
    NSString* urlString = @"http://www.opensource.apple.com/source/Git/Git-26/src/git-htmldocs/git-commit.txt?txt";
    NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    // This is a very handy way to send an asynchronous method, but only available in iOS5+
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* resp, NSData* data, NSError* error)
     {
         sender.enabled = YES;
         NSString* receivedText = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
         self.textView.text = receivedText;
     }];
}
- (IBAction)installTextStub:(UISwitch *)sender {
    static id<OHHTTPStubsDescriptor> textStub = nil; // Note: no need to retain this value, it is retained by the OHHTTPStubs itself already
//        if (sender.on)
//        {
//            // Install
//            textStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
//                // This stub will only configure stub requests for "*.txt" files
//                return [request.URL.pathExtension isEqualToString:@"txt"];
//            } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
//                // Stub txt files with this
//                return [[OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"stub.txt", self.class)
//                                                         statusCode:200
//                                                            headers:@{@"Content-Type":@"text/plain"}]
//                        requestTime:[self shouldUseDelay] ? 2.f: 0.f
//                        responseTime:OHHTTPStubsDownloadSpeedWifi];
//            }];
//            textStub.name = @"Text stub";
//        }
//        else
//        {
//            // Uninstall
//            [OHHTTPStubs removeStub:textStub];
//        }
    
    if (sender.on)
    {
        // Install
        textStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            // This stub will only configure stub requests for "*.txt" files
            return YES;
        } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
            // Stub txt files with this
            OHHTTPStubsResponse *ohHTTPStubsResponse = [[[[OHHTTPStubsResponse alloc] init] requestTime:[self shouldUseDelay] ? 2.f: 0.f
                                                                                           responseTime:OHHTTPStubsDownloadSpeedWifi] isOnlineMock:true] ;
            return ohHTTPStubsResponse ;
        }];
        textStub.name = @"Text stub";
    }
    else
    {
        // Uninstall
        [OHHTTPStubs removeStub:textStub];
    }
}

- (IBAction)downloadImage:(UIButton *)sender {
    sender.enabled = NO;
    
    NSString* urlString = @"http://images.apple.com/support/assets/images/products/iphone/hero_iphone4-5_wide.png";
    NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    // This is a very handy way to send an asynchronous method, but only available in iOS5+
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* resp, NSData* data, NSError* error)
     {
         sender.enabled = YES;
         self.imageView.image = [UIImage imageWithData:data];
     }];
}

- (IBAction)installImageStub:(UISwitch *)sender {
    static id<OHHTTPStubsDescriptor> imageStub = nil; // Note: no need to retain this value, it is retained by the OHHTTPStubs itself already :)
    if (sender.on)
    {
        // Install
        imageStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            // This stub will only configure stub requests for "*.png" files
            return [request.URL.pathExtension isEqualToString:@"png"];
        } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
            // Stub jpg files with this
            return [[OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"stub.jpg", self.class)
                                                     statusCode:200
                                                        headers:@{@"Content-Type":@"image/jpeg"}]
                    requestTime:[self shouldUseDelay] ? 2.f: 0.f
                    responseTime:OHHTTPStubsDownloadSpeedWifi];
        }];
        imageStub.name = @"Image stub";
    }
    else
    {
        // Uninstall
        [OHHTTPStubs removeStub:imageStub];
    }
}
- (IBAction)clearResults {
    self.textView.text = @"";
    self.imageView.image = nil;
}


@end
