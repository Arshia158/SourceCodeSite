# راهنمای خیلی ساده انتشار در GitHub و گرفتن APK

## مرحله ۱: ساخت repository

1. وارد GitHub شو.
2. روی دکمه New repository بزن.
3. یک اسم برای پروژه بگذار، مثلا:

```text
source-code-site
```

4. اگر میخواهی همه سورس را ببینند، Public را انتخاب کن. اگر فعلا تمرینی است، Private بهتر است.
5. repository را بساز.

## مرحله ۲: آپلود پروژه

اگر با Git آشنا نیستی، ساده ترین راه این است:

1. وارد صفحه repository شو.
2. گزینه Add file را بزن.
3. Upload files را انتخاب کن.
4. فایل های داخل پوشه پروژه را آپلود کن، نه خود فایل zip را.
5. پایین صفحه روی Commit changes بزن.

## مرحله ۳: فعال بودن Actions

1. در repository برو به تب Actions.
2. اگر GitHub پرسید، workflow ها را فعال کن.
3. باید workflow با نام زیر را ببینی:

```text
Build Android APK Release
```

## مرحله ۴: گرفتن خروجی APK بدون Release

1. برو به تب Actions.
2. workflow با نام Build Android APK Release را باز کن.
3. روی Run workflow بزن.
4. بعد از تمام شدن، پایین صفحه قسمت Artifacts را باز کن.
5. فایل source-code-site-apk را دانلود کن.

این روش برای تست سریع خوب است، اما Release رسمی نمیسازد.

## مرحله ۵: ساخت Release رسمی با APK

راه حرفه ای این است که یک tag بسازی.

روی سیستم خودت داخل پوشه پروژه این دستورها را بزن:

```bash
git add .
git commit -m "Prepare GitHub release"
git branch -M main
git remote add origin YOUR_REPOSITORY_URL
git push -u origin main
git tag v1.0.0
git push origin v1.0.0
```

بعد از push شدن tag، GitHub Actions خودش APK میسازد و داخل Release نسخه `v1.0.0` قرار میدهد.

## مرحله ۶: اگر با دستورها راحت نیستی

از روش Upload files استفاده کن و بعد از تب Actions گزینه Run workflow را بزن. این روش خروجی APK میدهد، ولی برای Release رسمی بهتر است بعدا tag بسازی.

## کدام APK را نصب کنم؟

برای بیشتر گوشی های جدید، این فایل مناسب است:

```text
arm64-v8a
```

اگر نصب نشد، نسخه universal نداریم چون پروژه برای کاهش حجم با split-per-ABI ساخته میشود. در آن حالت میتوانی workflow را تغییر بدهی و دستور build را به این تبدیل کنی:

```bash
flutter build apk --release
```
