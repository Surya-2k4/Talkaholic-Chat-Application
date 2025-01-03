// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:pdf_render/pdf_render.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as path;

// class PdfToImagePage extends StatefulWidget {
//   @override
//   _PdfToImagePageState createState() => _PdfToImagePageState();
// }

// class _PdfToImagePageState extends State<PdfToImagePage> {
//   String? _pdfFilePath;
//   List<File> _imageFiles = [];
//   bool _isLoading = false;

//   Future<void> _pickPdfFile() async {
//     try {
//       final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

//       if (result != null && result.files.single.path != null) {
//         setState(() {
//           _pdfFilePath = result.files.single.path;
//           _imageFiles = [];
//           _isLoading = true;
//         });
//         await _convertPdfToImages();
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('No PDF file selected.')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error picking PDF file: $e')),
//       );
//     }
//   }

//   Future<void> _convertPdfToImages() async {
//     if (_pdfFilePath == null) return;

//     try {
//       final document = await PdfDocument.openFile(_pdfFilePath!);
//       final tempDir = await getTemporaryDirectory();

//       for (int i = 1; i <= document.pageCount; i++) {
//         final page = await document.getPage(i);
//         final pageImage = await page.render();

//         if (pageImage.pixels == null) {
//           throw Exception("Failed to render page $i");
//         }

//         final imageFile = File(path.join(tempDir.path, 'page_$i.png'));
//         await imageFile.writeAsBytes(pageImage.by!);

//         setState(() {
//           _imageFiles.add(imageFile);
//         });
        
//       }

      
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('PDF converted to images and saved.')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to convert PDF: $e')),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('PDF to Image Converter')),
//       body: Column(
//         children: [
//           ElevatedButton(
//             onPressed: _pickPdfFile,
//             child: Text('Pick PDF File'),
//           ),
//           if (_isLoading)
//             Center(child: CircularProgressIndicator())
//           else if (_imageFiles.isNotEmpty)
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _imageFiles.length,
//                 itemBuilder: (context, index) {
//                   return Column(
//                     children: [
//                       Text('Page ${index + 1}'),
//                       Image.file(_imageFiles[index]),
//                     ],
//                   );
//                 },
//               ),
//             )
//           else
//             Center(child: Text('No PDF file selected or converted.')),
//         ],
//       ),
//     );
//   }
// }
