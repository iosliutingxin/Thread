//
//  ViewController.m
//  多线程
//
//  Created by 李孔文 on 2018/4/27.
//  Copyright © 2018年 Sunning. All rights reserved.
//

#import "ViewController.h"
#import <pthread.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self thread01];
}

//耗时操作
-(void)test01{
    
    for (int i = 0; i < 50000; i ++) {
        NSLog(@"%d",i);
        NSLog(@"当前线程 %@",[NSThread currentThread]);
    }
}
/*
 在ios真正的多线程技术是Pthread 和 NSThread
 
 注意：
 多线程的开发中不要相信一次线程的执行结果
 
 返回值：
 1、如果为0，则表示正确
 2、如果为非0，则表示错误
 
 __bridge
 早ARC开发中，涉及到和C语言中相同的数据类型转换，需要用到__bridge “桥接” 进行内存管理
 
 void *      (*)        (void *)
 返回值    （函数指针）    （参数）
 void *    和oc中的id   是等价的
 
 **/

#pragma pthread
-(void)pthreadTest01{
    
    pthread_t threadId;
    NSString *str = @"hello world";
    int result = pthread_create(&threadId, NULL, &demo, (__bridge void *)(str));
    if (result == 0) {
        NSLog(@"正确");
    }else{
        NSLog(@"错误");
    }
}

//c语言函数
void *demo(void *param){
    NSLog(@"当前线程%@",[NSThread currentThread]);
    return NULL;
}

#pragma NSThread
-(void)thread01{
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(threadFunction01:) object:@"hello world"];
    [thread start];
}

-(void)thread02{
    
    [NSThread detachNewThreadSelector:@selector(threadFunction01:) toTarget:self withObject:@"hello world"];
}

-(void)thread03{
    
    [self performSelectorInBackground:@selector(threadFunction01:) withObject:self];
}

-(void)threadFunction01:(id)object{
    
    NSLog(@"thread--->当前线程%@",[NSThread currentThread]);

    
}
@end
