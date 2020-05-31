import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:yaml/yaml.dart';

/**
 * Swagger to API route.
 */
Future<void> main() async {
  var result = <Map>[];
  const PATH_NAME = 'urlPath';
  const HTTP_METHOD = 'httpMethod';
  const CREATE_FILE_PATH_AND_NAME = './output/route.json';
  const SOURCE_Directory_PATH = './source';

  try {
    var dir = Directory(SOURCE_Directory_PATH);
    List contents = dir.listSync();
    for (var fileOrDir in contents) {
      // Read file.
      var content = await new File(fileOrDir.path).readAsString();
      Map doc = loadYaml(content);
      for (String path in doc['paths'].keys) {
        for (String item in doc['paths'][path].keys) {
          result.add({PATH_NAME: path, HTTP_METHOD: item});
        }
      }
    }

    // Create file.
    await new File(CREATE_FILE_PATH_AND_NAME).create(recursive: true);

    // Write file.
    await new File(CREATE_FILE_PATH_AND_NAME)
        .writeAsString(json.encode(result));

    // Catch file system exception
  } on FileSystemException catch (e) {
    print(e);
  }
}
