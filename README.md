## MXImageManager
#### 简介
基于SDWebImage的图片管理
#### 安装使用
```Swift
pod 'MXImageManager' '1.1.5'

AppDelegate.h
[MXImageCache mx_cancelSDMemoryCache];
```
#### 依赖库

```Swift
SDWegImage '5.0.6'
```
#### 文件结构
![](demo.png)
#### 说明

```Swift
 [self.cellImageView mx_setImageUrl:imgUrl fittedSize:CGSizeMake(self.imgWidth, self.imgHeight) palceholder:nil];
 
 UIImage *image = [MXImageCache mx_getImageForKey:self.cacheKey];
    if (!image) {
        NSLog(@"no image found from disk cache");
    }
    
NSLog(@"start download from server...");
UIImageView *imageView = [self.view viewWithTag:100];
[imageView mx_setImageUrl:self.origralUrl
               fittedSize:CGSizeMake(self.width, self.height)
              placeholder:nil
               completion:^(UIImage * _Nonnull image) {
                 NSLog(@"finish download...");                       
                 UIImage *origralImage = [MXImageCache  mx_getImageForKey:self.origralUrl];
                    if (!origralImage) {
                        NSLog(@"has clear origralImage from disk");
                    }
}];  
```
#### LICENSE
`MIT LICENSE`

