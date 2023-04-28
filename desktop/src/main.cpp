#include "cbl/CouchbaseLite.h"
#include <iostream>
#include <string>

using namespace std;

static string toString(FLSlice slice) {
    return string((const char*)slice.buf, slice.size);
}

int main() {
    cout << "Library : CBL-C " << CBLITE_VERSION << "-" << CBLITE_BUILD_NUMBER;
#ifdef COUCHBASE_ENTERPRISE
    cout << " (Enterprise)";
#else
    cout << " (Community)";
#endif
    cout << endl;

    bool success = true;

    CBLError error {};

    CBLDatabaseConfiguration config = CBLDatabaseConfiguration_Default();

    cout << "Directory : " << toString(config.directory) << endl;

#ifdef COUCHBASE_ENTERPRISE
    CBLEncryptionKey key;
    CBLEncryptionKey_FromPassword(&key, FLStr("sekrit"));
    config.encryptionKey = key;
    cout << "Use db encryption : true" << endl;
#else
    cout << "Use db encryption : false" << endl;
#endif

    const FLSlice dbname = FLStr("verify-db");
    if (CBL_DatabaseExists(dbname, config.directory)) {
        if (!CBL_DeleteDatabase(dbname, config.directory, &error)) {
            cerr << "Failed : cannot delete database, code = " << error.code << endl;
            success = false;
        }
    }

    CBLDatabase *db = nullptr;
    if (success) {
        db = CBLDatabase_Open(dbname, &config, &error);
        if (!db) {
            cerr << "Failed : cannot open database, code = " << error.code << endl;
            success = false;
        }
    }

    CBLCollection* coll = nullptr;
    if (success) {
        coll = CBLDatabase_CreateCollection(db, FLStr("tasks"), FLStr("todo"), &error);
        if (!coll) {
            cerr << "Failed : cannot create collection, code = " << error.code << endl;
            success = false;
        }
    }

    CBLDocument* doc = nullptr;
    if (success) {
        doc = CBLDocument_CreateWithID(FLStr("doc1"));
        FLMutableDict props = CBLDocument_MutableProperties(doc);
        FLMutableDict_SetString(props, FLStr("name"), FLStr("Verify CBL-C"));

        if (!CBLCollection_SaveDocument(coll, doc, &error)) {
            cerr << "Failed : invalid document count, code = " << error.code << endl;
            success = false;
        }
    }

    if (success) {
        if (CBLCollection_Count(coll) != 1) {
            cerr << "Failed : cannot save a document" << endl;
            success = false;
        }
    }

    CBLDocument_Release(doc);
    CBLCollection_Release(coll);
    CBLDatabase_Release(db);

    cout << "Result : " << (success ? "Passed" : "Failed") << endl;

    return success ? 0 : 1;
}
