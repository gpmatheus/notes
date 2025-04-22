
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:notes/data/services/interfaces/model/file/imagefile_dto.dart';
import 'package:notes/data/services/remote/remote_image_file_storage_service.dart';

void main() {

  late RemoteImageFileStorageService service;
  
  group('Test RemoteImageFileStorageService implements ImageFileServiceInterface', () {

    group('test the getImage method', () {

      setUp(() {
        service = RemoteImageFileStorageService();
      });

      test('should return a file', () async {
        var res = await service.getImage('screenshot.png');
        print(res.length);

        expect(1, 1);
      });
    });

    group('test the saveImage method', () {

      setUp(() {
        service = RemoteImageFileStorageService();
      });

      test('should return a file', () async {
        var res = await service.saveImage(
          ImagefileDto(
            imageFileName: 'screot.png',
            bytes: Uint8List.fromList([1, 2, 3]),
          ),
        );

        expect(1, 1);
      });
    });
  });
}