#include <jni.h>
#include <sstream>
#include <string>
#include <android/log.h>
#include "cbl/CouchbaseLite.h"

using namespace std;
using namespace fleece;

class AndroidLog {
public:
    static constexpr const char* LOG_TAG = "CBLC-Verify";

    static void log(CBLLogLevel level, string message) {
        int logLevel;
        switch (level) {
            case kCBLLogDebug:
                logLevel = ANDROID_LOG_DEBUG;
                break;
            case kCBLLogVerbose:
                logLevel = ANDROID_LOG_VERBOSE;
                break;
            case kCBLLogInfo:
                logLevel = ANDROID_LOG_INFO;
                break;
            case kCBLLogWarning:
                logLevel = ANDROID_LOG_WARN;
                break;
            case kCBLLogError:
                logLevel = ANDROID_LOG_ERROR;
                break;
            default:
                logLevel = ANDROID_LOG_UNKNOWN;
        }
        __android_log_write(logLevel, LOG_TAG, message.c_str());
    }
};

static string toString(FLSlice slice) {
    return string((const char*)slice.buf, slice.size);
}

extern "C" JNIEXPORT jboolean JNICALL
Java_com_couchbase_tests_CouchbaseLiteTest_verify(
        JNIEnv* env,
        jobject /* this */,
        jstring filesDir,
        jstring tmpDir) {
    const char* cFilesDir = env->GetStringUTFChars(filesDir, NULL);
    const char* cTmpDir = env->GetStringUTFChars(tmpDir, NULL);

    // Initialize Android Context:
    bool success = CBL_Init({cFilesDir, cTmpDir}, NULL);
    env->ReleaseStringUTFChars(filesDir, cFilesDir);
    env->ReleaseStringUTFChars(tmpDir, cTmpDir);
    if (!success) {
        AndroidLog::log(kCBLLogError, "Failed to init android context");
        return false;
    }
    stringstream info;
    info << "Library : CBL-C " << CBLITE_VERSION << "-" << CBLITE_BUILD_NUMBER;
#ifdef COUCHBASE_ENTERPRISE
    info << " (Enterprise)";
#else
    info << " (Community)";
#endif
    AndroidLog::log(kCBLLogInfo, info.str());

    CBLDatabaseConfiguration config = CBLDatabaseConfiguration_Default();
    AndroidLog::log(kCBLLogInfo, "Directory : " + toString(config.directory));

#ifdef COUCHBASE_ENTERPRISE
    CBLEncryptionKey key;
    CBLEncryptionKey_FromPassword(&key, FLStr("sekrit"));
    config.encryptionKey = key;
    AndroidLog::log(kCBLLogInfo, "Use db encryption : true");
#else
    AndroidLog::log(kCBLLogInfo, "Use db encryption : false");
#endif

    CBLError error {};
    const FLSlice dbname = FLStr("verify-db");
    if (CBL_DatabaseExists(dbname, config.directory)) {
        if (!CBL_DeleteDatabase(dbname, config.directory, &error)) {
            AndroidLog::log(kCBLLogError, "Failed : cannot delete database, code = " + to_string(error.code));
            success = false;
        }
    }

    CBLDatabase *db = nullptr;
    if (success) {
        db = CBLDatabase_Open(dbname, &config, &error);
        if (!db) {
            AndroidLog::log(kCBLLogError, "Failed : cannot open database, code = " + to_string(error.code));
            success = false;
        }
    }

    CBLCollection* coll = nullptr;
    if (success) {
        coll = CBLDatabase_CreateCollection(db, FLStr("tasks"), FLStr("todo"), &error);
        if (!coll) {
            AndroidLog::log(kCBLLogError, "cannot create collection, code = " + to_string(error.code));
            success = false;
        }
    }

    CBLDocument* doc = nullptr;
    if (success) {
        doc = CBLDocument_CreateWithID(FLStr("doc1"));
        FLMutableDict props = CBLDocument_MutableProperties(doc);
        FLMutableDict_SetString(props, FLStr("name"), FLStr("Verify CBL-C"));

        if (!CBLCollection_SaveDocument(coll, doc, &error)) {
            AndroidLog::log(kCBLLogError, "Failed : cannot save a document, code = " + to_string(error.code));
            success = false;
        }
    }

    if (success) {
        if (CBLCollection_Count(coll) != 1) {
            AndroidLog::log(kCBLLogError, "Invalid document count");
            success = false;
        }
    }

    CBLDocument_Release(doc);
    CBLCollection_Release(coll);
    CBLDatabase_Release(db);

    AndroidLog::log(kCBLLogInfo, (success ? "Passed" : "Failed"));

    return success;
}
