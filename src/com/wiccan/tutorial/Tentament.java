package com.wiccan.tutorial;

import android.app.Activity;
import android.util.Log;
import android.os.Bundle;

public class Tentament extends Activity {

    private static final String TAG = "Tentament";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Log.e(TAG, "TENTAMENT got this far, now FINISHing");

        finish();
    }
}
