---
title: Hexo博客－性能优化之静态文件压缩
author: Hazelnut Latte
tags:
  - Hexo
categories: Hexo
date: 2016-10-12
urlname: hexo-performance-optimization
---

<!-- ## Hexo博客－性能优化之静态文件压缩 -->

### 使用Gulp优化Hexo

#### 1.安装依赖

```shell
$ npm install gulp gulp-uglify gulp-clean-css gulp-htmlmin gulp-htmlclean gulp-imagemin gulp-concat --save-dev
```

如果安装的依赖和已经存在的依赖有冲突 , 可在 `package.json` 中添加以下开发依赖 :

```shell
"devDependencies": {
    "gulp": "^3.9.1",
    "gulp-concat": "^2.6.1",
    "gulp-htmlclean": "^2.7.15",
    "gulp-htmlmin": "^3.0.0",
    "gulp-imagemin": "^3.3.0",
    "gulp-clean-css": "^2.3.2",
    "gulp-uglify": "^3.0.0"
}
```
<!-- more -->
#### 2.创建 gulpfile.js

在 `hexo blog` 的根目录文件夹下创建 `gulpfile.js` :

写入以下内容 :

```javascript
let gulp = require('gulp'),
  uglify = require('gulp-uglify'),
  cssmin = require('gulp-clean-css'),
  imagemin = require('gulp-imagemin'),
  htmlmin = require('gulp-htmlmin'),
  htmlclean = require('gulp-htmlclean');
concat = require('gulp-concat');
//JS压缩
gulp.task('uglify', function() {
  return gulp
    .src(['./public/js/**/.js', '!./public/js/**/*min.js']) //只是排除min.js文件还是不严谨，一般不会有问题，根据自己博客的修改我的修改为return gulp.src(['./public/**/*.js','!./public/zuoxi/**/*.js',,'!./public/radio/**/*.js'])
    .pipe(uglify())
    .pipe(gulp.dest('./public/js')); //对应修改为./public即可
});
//public-fancybox-js压缩
gulp.task('fancybox:js', function() {
  return gulp
    .src('./public/vendors/fancybox/source/jquery.fancybox.js')
    .pipe(uglify())
    .pipe(gulp.dest('./public/vendors/fancybox/source/'));
});
// 合并 JS
gulp.task('jsall', function() {
  return (
    gulp
      .src('./public/**/*.js')
      // 压缩后重命名
      .pipe(concat('app.js'))
      .pipe(gulp.dest('./public'))
  );
});
//public-fancybox-css压缩
gulp.task('fancybox:css', function() {
  return gulp
    .src('./public/vendors/fancybox/source/jquery.fancybox.css')
    .pipe(cssmin())
    .pipe(gulp.dest('./public/vendors/fancybox/source/'));
});
//CSS压缩
gulp.task('cssmin', function() {
  return gulp
    .src(['./public/css/main.css', '!./public/css/*min.css'])
    .pipe(cssmin())
    .pipe(gulp.dest('./public/css/'));
});
//图片压缩
gulp.task('minify-img-aggressive', function() {
    return gulp.src('./public/medias/**/*.*')
        .pipe(imagemin(
        [imagemin.gifsicle({'optimizationLevel': 3}),
        imagemin.jpegtran({'progressive': true}),
        imagemin.optipng({'optimizationLevel': 7}),
        imagemin.svgo()],
        {'verbose': true}))
        .pipe(gulp.dest('./public/medias'))
});
// 压缩 public 目录 html文件 public/**/*.hmtl 表示public下所有文件夹中html，包括当前目录
gulp.task('minify-html', function() {
  return gulp
    .src('./public/**/*.html')
    .pipe(htmlclean())
    .pipe(
      htmlmin({
        removeComments: true,
        minifyJS: true,
        minifyCSS: true,
        minifyURLs: true
      })
    )
    .pipe(gulp.dest('./public'));
});

gulp.task('build', [
  'uglify',
  'jsall',
  'cssmin',
  'minify-img-aggressive',
  'fancybox:js',
  'fancybox:css',
  'minify-html'
]);
```

#### 2.执行优化命令

```shell
$ hexo clean
$ hexo g
$ gulp build
$ hexo d
```

连续执行4个命令太麻烦， 可以直接在根目录下的 `package.json` 文件中生成写入 `scripts` :

```shell
"scripts": {
  "build": "hexo clean && hexo g && gulp build && hexo deploy"
  }
```

然后执行命令 :

```shell
$ npm run build
```

以前都是使用 `hexo clean`  ,  `hexo g`  , `hexo d` 来自动更新博文，虽然命令不长，还是不如上面一条命令来的直接 !

至此，可以得到一个 `html` 、`css` 、`js` 、`image` 都更优化的 `/public  `文件夹，我用评测工具测试了一下博客打开速度, 确实快了不少 !
