# JLPhotoBrowser
一款简单的图片浏览器
用法示例：
```
    NSMutableArray *photos = [NSMutableArray array];
    
    for (int i=0; i<self.imageViews.count; i++) {
        
        UIImageView *child = self.imageViews[i];
        //1.创建photo模型
        JLPhoto *photo = [[JLPhoto alloc] init];
        //2.原始imageView
        photo.sourceImageView = child;
        //3.要放大图片的url
        photo.bigImgUrl = self.bigImgUrls[i];
        //标志
        photo.tag = i;
        
        [photos addObject:photo];
        
    }
    
    //1.创建图片浏览器
    JLPhotoBrowser *photoBrowser = [[JLPhotoBrowser alloc] init];
    //2.获取photo数组
    photoBrowser.photos = photos;
    //3.当前要显示的图片
    photoBrowser.currentIndex = (int)tap.view.tag;
    [photoBrowser show];
```
![image](https://github.com/JlongTian/JLPhotoBrowser/show.gif)

