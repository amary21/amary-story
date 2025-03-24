import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

Future<File> imageCompress(File imageFile) async {
  Uint8List imageBytes = await imageFile.readAsBytes();
  img.Image? image = img.decodeImage(imageBytes);
  if (image == null) return imageFile;

  int quality = 90;
  List<int> compressedBytes;
  File compressedFile = imageFile;

  do {
    compressedBytes = img.encodeJpg(image, quality: quality);
    quality -= 10;
  } while (compressedBytes.length > 1000000 && quality > 10);

  compressedFile = File(imageFile.path)..writeAsBytesSync(compressedBytes);
  return compressedFile;
}
