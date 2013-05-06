
#Test Activity to demonstrate a problem with the following issue regarding
`AndroidManifest.xml`

This build is on a customized version of AOSP based on `android-4.2.2_r1`
The activity `Tentament` is poised to run after `SetupWizardActivity`.
`SetupWizardActivity` helps the user set up his Google account and various
settings. It comes bundled with the other various google apps like Play
Store, Gmail, and Maps.

    <activity
        android:name=".tutorial.Tentament"
        android:clearTaskOnLaunch="true"
        android:excludeFromRecents="true"
        android:launchMode="singleTop"
        android:configChanges="mcc|mnc|locale|touchscreen|keyboard|keyboardHidden|navigation|screenLayout|fontScale|uiMode|orientation|screenSize|smallestScreenSize"
        android:theme="@android:style/Theme.Holo.NoActionBar.Fullscreen" >
        <intent-filter android:priority="1">
            <action android:name="android.intent.action.MAIN" />
            <category android:name="android.intent.category.DEFAULT" />
            <action android:name="android.intent.action.DEVICE_INITIALIZATION_WIZARD"/>
            <category android:name="android.intent.category.HOME" />
        </intent-filter>
    </activity>

The above portion is similar to how `SetupWizardActivity` is launched in its
AndroidManifest.xml.  The XML file was reconstructed using dex2jar and jd-gui
on the bundled google apps. The XML files also bears similarity to the
AndroidManifest.xml file for `packages/apps/Provision/AndroidManifest.xml`
included in AOSP:

    <activity
        android:theme="@style/InvisibleNoTitle"
        android:label="@string/setup_wizard_title"
        android:name="SetupWizardActivity"
        android:excludeFromRecents="true"
        android:launchMode="singleTop"
        android:immersive="true">
        <intent-filter android:priority="5">
            <action android:name="android.intent.action.MAIN" />
            <action android:name="android.intent.action.DEVICE_INITIALIZATION_WIZARD" />
            <category android:name="android.intent.category.HOME" />
            <category android:name="android.intent.category.DEFAULT" />
        </intent-filter>
    </activity>

I've also included the manifest file for `SetupWizardActivity` and other google
apps as `SetupWizard.AndroidManifest.xml` at the root of this repository.

After `SetupWizardActivity`, `Tentament` ends up running and exits.
`SetupWizardActivity` gets called again, and then the device gets stuck while
in `SetupWizardActivity` again. Some buttons on the device are enabled but I
end up being stuck in `SetupWizardActivity` with a black screen. I cannot get
out of it without locking the phone, unlocking, along with some other strange
combination of keys to get to the home screen.

Further information is included in the file [boot.log](boot.log) at the root of
this repository. The messages were filtered using 

    `adb logcat | grep -iE "setupwizard|tentament" | tee boot.log`

I'm picking out what I think are some of the more relevant messages:

    E/Tentament( 1772): TENTAMENT got this far, now FINISHing
    ...
    I/ActivityManager(  513): Start proc com.google.android.setupwizard for activity com.google.android.setupwizard/.SetupWizardActivity: pid=1786 uid=10054 gids={50054, 3003, 1028}
    I/SetupWizard( 1786): SetupWizardActivity.onCreate(icicle) LTE == false userID=0
    D/SetupWizard( 1786): BaseActivity.onCreate() mIsFirstRun=true mAllNetworkSetupSkipped=true mIsSecondaryUser=false
    W/SetupWizard( 1786): skip disabling notfictions due to isHomeActivity() == false


What I have noticed is that if `android:priority="1"` is increased to a value
over 5, like `android:priority="10"`, `Tentament` ends up running before
`SetupWizardActivity` and then no issues arise. Priority just handles the order
that the apps are launched, as far as I can tell. 
