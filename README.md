# SourceCodeSite

یک اپلیکیشن موبایل ساخته شده با Flutter برای دریافت، نمایش، کپی، ذخیره و اشتراک گذاری سورس HTML صفحات وب.

[![Download APK](https://img.shields.io/badge/Download%20APK-Latest%20Release-blue?style=for-the-badge\&logo=android)](https://github.com/Arshia158/SourceCodeSite/releases/latest)
[![Flutter](https://img.shields.io/badge/Built%20with-Flutter-02569B?style=for-the-badge\&logo=flutter)](https://flutter.dev)
[![Android](https://img.shields.io/badge/Platform-Android-3DDC84?style=for-the-badge\&logo=android)](https://developer.android.com)

## دانلود و نصب اپلیکیشن

برای نصب برنامه روی اندروید، از بخش Releases آخرین نسخه APK را دانلود کنید:

[دانلود آخرین نسخه APK](https://github.com/Arshia158/SourceCodeSite/releases/latest)

پیشنهاد برای بیشتر گوشی های اندرویدی:

`app-arm64-v8a-release.apk`

اگر گوشی شما قدیمی تر است:

`app-armeabi-v7a-release.apk`

اگر از شبیه ساز اندروید استفاده می کنید:

`app-x86_64-release.apk`

## راهنمای نصب روی اندروید

1. وارد صفحه آخرین Release شوید.
2. فایل APK مناسب گوشی خود را دانلود کنید.
3. فایل دانلود شده را باز کنید.
4. اگر اندروید پیام امنیتی نشان داد، اجازه نصب از مرورگر یا فایل منیجر را فعال کنید.
5. برنامه را نصب و اجرا کنید.

چون این برنامه از Google Play نصب نمی شود، ممکن است هنگام نصب پیام هشدار نمایش داده شود. این موضوع برای فایل های APK که به صورت دستی نصب می شوند طبیعی است.

## معرفی پروژه

SourceCodeSite یک اپلیکیشن ساده و کاربردی برای مشاهده سورس HTML صفحات وب است.

کاربر می تواند لینک یک صفحه وب را وارد کند و سورس HTML آن صفحه را دریافت، مشاهده، کپی، ذخیره یا اشتراک گذاری کند.

این پروژه برای یادگیری، نمونه کار، توسعه شخصی و استفاده های آموزشی منتشر شده است.

## قابلیت ها

* دریافت سورس HTML از لینک وارد شده
* نمایش سورس در محیطی شبیه کد ادیتور
* کپی کامل سورس صفحه
* ذخیره خروجی به صورت فایل HTML در اندروید
* اشتراک گذاری سورس دریافت شده
* پشتیبانی از حالت روشن و تاریک سیستم
* رابط کاربری فارسی و راست به چپ
* ساخت خودکار APK با GitHub Actions
* انتشار نسخه های APK در بخش GitHub Releases

## تکنولوژی های استفاده شده

* Flutter
* Dart
* Android
* GitHub Actions
* Gradle

## ساختار کلی پروژه

```text
SourceCodeSite/
├── android/
├── lib/
├── test/
├── .github/
│   └── workflows/
│       └── android-apk-release.yml
├── pubspec.yaml
├── README.md
├── CHANGELOG.md
└── SECURITY.md
```

## اجرای پروژه برای توسعه دهنده ها

برای اجرای پروژه روی سیستم خود، ابتدا پیش نیازهای Flutter را نصب کنید.

سپس دستورهای زیر را اجرا کنید:

```bash
flutter pub get
flutter run
```

## ساخت APK روی سیستم شخصی

برای ساخت خروجی APK به صورت دستی:

```bash
flutter build apk --release --split-per-abi
```

بعد از پایان build، فایل های APK در مسیر زیر ساخته می شوند:

```text
build/app/outputs/flutter-apk/
```

## انتشار خودکار APK در GitHub

این پروژه دارای workflow آماده برای GitHub Actions است.

مسیر فایل workflow:

```text
.github/workflows/android-apk-release.yml
```

با ساخت یک tag مثل نمونه زیر:

```text
v1.0.0
```

GitHub Actions به صورت خودکار پروژه را build می کند و فایل های APK را در بخش Release همان نسخه قرار می دهد.

## نسخه های APK

در حالت split-per-ABI معمولا سه خروجی APK ساخته می شود:

| فایل APK                      | مناسب برای                             |
| ----------------------------- | -------------------------------------- |
| `app-arm64-v8a-release.apk`   | بیشتر گوشی های جدید اندرویدی           |
| `app-armeabi-v7a-release.apk` | بعضی گوشی های قدیمی تر                 |
| `app-x86_64-release.apk`      | شبیه ساز اندروید و بعضی دستگاه های خاص |

## نام پکیج اندروید

```text
com.arshia.sourcecodesite
```

## نکات امنیتی

این پروژه نباید شامل اطلاعات محرمانه باشد.

موارد زیر را داخل repository قرار ندهید:

* فایل keystore
* رمز عبور
* API key
* access token
* فایل key.properties
* اطلاعات خصوصی سرور

این اپلیکیشن فقط باید برای بررسی صفحاتی استفاده شود که اجازه مشاهده و بررسی سورس آن ها را دارید.

## نسخه ها

برای مشاهده نسخه های منتشر شده:

[مشاهده همه Release ها](https://github.com/Arshia158/SourceCodeSite/releases)

## وضعیت پروژه

نسخه اولیه پروژه منتشر شده و خروجی APK آن از طریق GitHub Releases قابل دانلود است.

## License

This project is published for educational, portfolio and personal development purposes.
