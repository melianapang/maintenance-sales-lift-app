import 'package:flutter/services.dart';
import 'package:gcloud/storage.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:mime/mime.dart';

class GCloudService {
  GCloudService();

  auth.ServiceAccountCredentials? _credentials;

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    rootBundle.loadString('assets/credentials.json').then((String json) async {
      _credentials = auth.ServiceAccountCredentials.fromJson(json);
      _isInitialized = true;
    });
  }

  Future<ObjectInfo?> save(String name, Uint8List imgBytes) async {
    if (!_isInitialized) return null;
    // Create a client
    final auth.AutoRefreshingAuthClient client =
        await auth.clientViaServiceAccount(
      _credentials!,
      Storage.SCOPES,
    );

    // Instantiate objects to cloud storage
    var storage = Storage(client, 'My First Project');
    var bucket = storage.bucket('test-lift');

    // Save to bucket
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final type = lookupMimeType(name);
    return await bucket.writeBytes(
      name,
      imgBytes,
      metadata: ObjectMetadata(
        contentType: type,
        custom: {
          'timestamp': '$timestamp',
        },
      ),
    );
  }
}
