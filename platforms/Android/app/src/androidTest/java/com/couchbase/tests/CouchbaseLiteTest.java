package com.couchbase.tests;

import android.content.Context;
import androidx.test.platform.app.InstrumentationRegistry;
import androidx.test.ext.junit.runners.AndroidJUnit4;

import org.junit.Test;
import org.junit.runner.RunWith;

import static org.junit.Assert.*;

import java.io.File;

@RunWith(AndroidJUnit4.class)
public class CouchbaseLiteTest {
    static {
        System.loadLibrary("cbl_verify");
    }

    private static final String TEMP_DIR = "CBL_C_Verify_Temp";

    @Test
    public void testVerification() throws Exception {
        Context context = InstrumentationRegistry.getInstrumentation().getTargetContext();

        // Database Dir:
        String filesDir = context.getFilesDir().getPath();

        // Temp Dir:
        File tmpFileDir = new File(context.getFilesDir(), TEMP_DIR);
        tmpFileDir.mkdirs();
        String tmpDir = tmpFileDir.getPath();

        // Verify
        assertTrue(verify(filesDir, tmpDir));
    }

    public native boolean verify(String filesDir, String tmpDir);
}
