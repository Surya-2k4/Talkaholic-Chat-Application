import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart'; // For clipboard functionality



void main() {
  runApp(MaterialApp(
    home: TextToPdfPage(),
  ));
}

class TextToPdfPage extends StatefulWidget {
  @override
  _TextToPdfPageState createState() => _TextToPdfPageState();
}

class _TextToPdfPageState extends State<TextToPdfPage> {
  final TextEditingController _controller = TextEditingController();
  String? _extractedText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Text to PDF & PDF to Text')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Text Input Field
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Enter text',
                  border: OutlineInputBorder(),
                ),
                maxLines: 10,
              ),
              SizedBox(height: 20),

              // Buttons for Generate PDF and Preview Text
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final text = _controller.text;
                      if (text.isNotEmpty) {
                        await generatePdf(text);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('PDF created successfully!')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please enter some text.')),
                        );
                      }
                    },
                    child: Text('Generate PDF'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final text = _controller.text;
                      if (text.isNotEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Preview Text'),
                            content: SingleChildScrollView(
                              child: Text(text),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Close'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('No text to preview.')),
                        );
                      }
                    },
                    child: Text('Preview Text'),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Button for PDF to Text Conversion
              ElevatedButton(
                onPressed: () async {
                  await extractTextFromPdf();
                },
                child: Text('PDF to Text'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Generate PDF Function
  Future<void> generatePdf(String text) async {
    final pdf = PdfDocument();

    // Add a page with wrapped text
    final page = pdf.pages.add();
    final format = PdfStringFormat(lineSpacing: 5);
    page.graphics.drawString(
      'Talkaholic - PDF Generation\n\n$text',
      PdfStandardFont(PdfFontFamily.helvetica, 12),
      bounds: Rect.fromLTWH(0, 0, page.getClientSize().width, page.getClientSize().height),
      format: format,
    );

    // Save the PDF to the Downloads folder
    try {
      final directory = Directory('/storage/emulated/0/Download');
      final path = '${directory.path}/generated.pdf';
      final file = File(path);
      await file.writeAsBytes(await pdf.save());

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF saved at $path')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save PDF: $e')),
      );
    }
  }

  // Extract Text from PDF Function
  Future<void> extractTextFromPdf() async {
    try {
      // Open file picker to select PDF file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        // Get the selected file
        File file = File(result.files.single.path!);

        // Load the PDF document
        final PdfDocument document = PdfDocument(inputBytes: await file.readAsBytes());

        // Extract text from the PDF document
        final PdfTextExtractor extractor = PdfTextExtractor(document);
        String text = extractor.extractText();

        // Navigate to extracted text screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExtractedTextScreen(text: text),
          ),
        );

        // Dispose of the document after processing
        document.dispose();
      } else {
        // If no file is selected
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No file selected.')),
        );
      }
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to extract text from PDF: $e')),
      );
    }
  }

  // Get Downloads Directory
  Future<Directory?> getDownloadsDirectory() async {
    if (Platform.isAndroid) {
      return await getExternalStorageDirectory();
    } else {
      return await getApplicationDocumentsDirectory();
    }
  }
}

// Extracted Text Screen
class ExtractedTextScreen extends StatelessWidget {
  final String text;

  ExtractedTextScreen({required this.text});

  @override
  Widget build(BuildContext context) {
    final List<String> lines = text.split('\n');
    return Scaffold(
      appBar: AppBar(
        title: Text('Extracted Text'),
        actions: [
          IconButton(
            icon: Icon(Icons.copy),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: text));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Text copied to clipboard!')),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: lines.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(lines[index]),
          );
        },
      ),
    );
  }
}
