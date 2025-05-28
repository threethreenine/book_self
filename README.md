# book_shelf

基于 Open Library API 开发一个“书架”应用 BookShelf，供用户搜索图书、查看详情，并将感兴趣的图书加入“我的书架”进行离线管理；



### Directory structure

```
lib/
├── generated/             # 配置生成脚本
├── l10n/                  # 本地化配置文件
├── models/                # 数据
├── providers/             # 状态管理
├── repositories/          # hive本地数据处理
├── services/              # service API
└── ui/                 # UI实现
    └── dialogs/  
    └── elements/  
    └── pages/ 
    └── screens/ 
├── global_keys.dart 
├── main.dart  
            
```

### Check flutter environment

```bash
>flutter doctor -v
```

### Install dependencies

```bash
.\book_shelf>flutter pub get
```

### RUN

```bash
.\book_shelf>flutter run -d chrome
.\book_shelf>flutter run -d windows


```

### Android Build

在\book_shelf\android\gradle\wrapper\gradle-wrapper.properties中配置提前下载好的gradle包, 或者使用镜像：

```properties
distributionUrl=file:///C:/Users//.gradle/wrapper/dists/gradle-8.10.2-all.zip
distributionUrl=https\://mirrors.aliyun.com/macports/distfiles/gradle/gradle-8.10.2-all.zip
```



Traditional APK

```bash
.\book_shelf>flutter build apk
.\book_shelf>flutter run -v    // anther method
```

AppBundle for Google Play

```bash
.\book_shelf>flutter build appbundle
```

### Localization Update

```bash
// 全局安装intl_utils
.\book_shelf>dart pub global activate intl_utils
// 生成本地化文件
.\book_shelf>dart pub global run intl_utils:generate
```

### Hiv build

```bash
.\book_shelf>dart run build_runner build
```
