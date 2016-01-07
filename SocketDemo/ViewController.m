//
//  ViewController.m
//  SocketDemo
//
//  Created by 张洋威 on 16/1/7.
//  Copyright © 2016年 太阳花互动. All rights reserved.
//

//============================
#define yw_HOST @"localhost"
#define yw_PORT @"3000"
//============================

#import "ViewController.h"
#import "SocketDemo-Swift.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (nonatomic, strong) SocketIOClient *socket;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (SocketIOClient *)socket
{
    if (!_socket) {
        
        NSString *URL = [NSString stringWithFormat:@"%@:%@", yw_HOST, yw_PORT];
        _socket = [[SocketIOClient alloc] initWithSocketURL:URL opts:@{@"log": @NO}];
        
        __weak typeof(self)weakSelf = self;
        [_socket on:@"connected" callback:^(NSArray *array, SocketAckEmitter * emitter) {
            __strong typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.messageLabel.text = [NSString stringWithFormat:@"connected. UTC time:%@", [array firstObject]];
            strongSelf.connectButton.selected = YES;
            [strongSelf.socket emit:@"username" withItems:@[@"NO.1"]];
        }];
        
        [_socket on:@"pong" callback:^(NSArray * array, SocketAckEmitter * emitter) {
            __strong typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.messageLabel.text = [NSString stringWithFormat:@"%@", [array firstObject]];
        }];
    }
    
    return _socket;
}

- (IBAction)connectButtonAction:(UIButton *)sender {
    if (!sender.selected) {
        [self.socket connect];
    }
}

- (IBAction)sendMessageButtonAction:(UIButton *)sender {

    if (self.socket.status == SocketIOClientStatusConnected) {
        [_socket emit:@"ping" withItems:@[@"vivi is a genius."]];
    }
}

@end
