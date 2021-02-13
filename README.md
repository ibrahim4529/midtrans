# midtrans

Non Official Plugin For Integrate Flutter And Midtrans Mobile Sdk
This Plugin is running on snap mode in midtrans
You can red the documentation in this [url](https://mobile-docs.midtrans.com/)

## Getting Started

### Requirement
- A Client-Key from midtrans Merchant Account
- Merchant Server, A server side implementation is required 
  for Midtrans mobile SDK to work. You can check [the server 
  implementation reference](http://mobile-docs.midtrans.com/#merchant-server-implementation) and walk through the API’s that 
  you may need for implementation on your backend server.

After finish a requirement to use this plugin
You require to configure your project 
- Change AndroidManifest.xml to be like this
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.hello_example" xmlns:tools="http://schemas.android.com/tools">
   <application
        android:label="hello_example"
        android:icon="@mipmap/ic_launcher"
        tools:replace="android:label"
        android:theme="@style/AppTheme"
       >
        .....
    </application>
</manifest>
```
- Change styles.xml in your project 
you can find the xml in android/app/src/main/res/values/styles.xml
To be like this
```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <!-- Theme applied to the Android Window while the process is starting when the OS's Dark Mode setting is off -->
    <style name="LaunchTheme" parent="@android:style/Theme.Light.NoTitleBar">
        <!-- Show a splash screen on the activity. Automatically removed when
             Flutter draws its first frame -->
        <item name="android:windowBackground">@drawable/launch_background</item>
    </style>
    <!-- Theme applied to the Android Window as soon as the process has started.
         This theme determines the color of the Android Window while your
         Flutter UI initializes, as well as behind your Flutter UI while its
         running.
         
         This Theme is only used starting with V2 of Flutter's Android embedding. -->
    <style name="AppTheme" parent="Theme.AppCompat.Light.DarkActionBar">
        <item name="windowActionBar">false</item>
        <item name="windowNoTitle">true</item>
    </style>
    <style name="NormalTheme" parent="@android:style/Theme.Light.NoTitleBar">
        <item name="android:windowBackground">?android:colorBackground</item>
    </style>
</resources>
```

## Troubleshooting
If you found anny issue you can open issue in github or contact me

- Issue running error on debug mode 
Error code like this
```bash
E/AndroidRuntime(28442): java.lang.AssertionError
E/AndroidRuntime(28442): 	at com.koushikdutta.async.AsyncSSLSocketWrapper.write(AsyncSSLSocketWrapper.java:390)
E/AndroidRuntime(28442): 	at com.koushikdutta.async.AsyncSSLSocketWrapper.handleHandshakeStatus(AsyncSSLSocketWrapper.java:276)
E/AndroidRuntime(28442): 	at com.koushikdutta.async.AsyncSSLSocketWrapper.handshake(AsyncSSLSocketWrapper.java:114)
E/AndroidRuntime(28442): 	at com.koushikdutta.async.http.AsyncSSLSocketMiddleware.tryHandshake(AsyncSSLSocketMiddleware.java:89)
E/AndroidRuntime(28442): 	at com.koushikdutta.async.http.AsyncSSLSocketMiddleware$2.onConnectCompleted(AsyncSSLSocketMiddleware.java:106)
E/AndroidRuntime(28442): 	at com.koushikdutta.async.AsyncServer.runLoop(AsyncServer.java:849)
E/AndroidRuntime(28442): 	at com.koushikdutta.async.AsyncServer.run(AsyncServer.java:658)
E/AndroidRuntime(28442): 	at com.koushikdutta.async.AsyncServer.access$800(AsyncServer.java:44)
E/AndroidRuntime(28442): 	at com.koushikdutta.async.AsyncServer$14.run(AsyncServer.java:600)
```
This error cause third party library used bay midtrans mobile sdk 
to solve this you can run in release mode or change your gradle version
to version lower or equal to 4.0.2

To change your gradle version change file in android/build.gradle
to like this
```properties
dependencies {
        classpath 'com.android.tools.build:gradle:4.0.2'
        .....
}
```
