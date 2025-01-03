import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/services.dart'; // For copying to clipboard

void main() {
  runApp(MaterialApp(home: EncryptionPage()));
}

class EncryptionPage extends StatefulWidget {
  @override
  _EncryptionPageState createState() => _EncryptionPageState();
}

class _EncryptionPageState extends State<EncryptionPage> {
  TextEditingController textController = TextEditingController();
  TextEditingController keyController = TextEditingController();
  TextEditingController encryptedController = TextEditingController();
  TextEditingController decryptedController = TextEditingController();

  String encryptedText = '';
  String decryptedText = '';

  // A 32-byte key for AES encryption, can be generated or securely stored
  final encrypt.Key key = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows1');
  final encrypt.IV iv = encrypt.IV.fromLength(16); // Initialization vector for AES

  void encryptText() {
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(textController.text, iv: iv);

    setState(() {
      encryptedText = encrypted.base64;
      encryptedController.text = encryptedText;
    });
  }

  void decryptText() {
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final decrypted = encrypter.decrypt64(encryptedText, iv: iv);

    setState(() {
      decryptedText = decrypted;
      decryptedController.text = decryptedText;
    });
  }

  // Function to copy text to clipboard
  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Text copied to clipboard!")));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2C3E50), // Dark gray background (more formal)
      appBar: AppBar(
        title: Text('Encryption & Decryption', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
        backgroundColor: Color(0xFF34495E), // Deep blue (professional color)
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Heading
              Text(
                'Enter Text to Encrypt',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              
              // Original Text Field
              _buildTextField(
                controller: textController,
                label: 'Original Text',
                hint: 'Enter your text here',
              ),
              SizedBox(height: 16),

              // Encrypt Button
              _buildActionButton('Encrypt Text', encryptText),
              SizedBox(height: 16),

              // Encrypted Text Field
              Text(
                'Encrypted Text (Base64)',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              _buildTextField(
                controller: encryptedController,
                label: 'Encrypted Text',
                hint: 'Encrypted text will appear here',
                isReadOnly: true,
                actionButton: IconButton(
                  icon: Icon(Icons.copy, color: Colors.blueGrey), // Formal copy icon color
                  onPressed: () => copyToClipboard(encryptedText),
                ),
              ),
              SizedBox(height: 16),

              // Decrypt Button
              _buildActionButton('Decrypt Text', decryptText),
              SizedBox(height: 16),

              // Decrypted Text Field
              Text(
                'Decrypted Text',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              _buildTextField(
                controller: decryptedController,
                label: 'Decrypted Text',
                hint: 'Decrypted text will appear here',
                isReadOnly: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build text fields with customizable properties
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool isReadOnly = false,
    Widget? actionButton,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color(0xFFBDC3C7), width: 1.5), // Light gray border
      ),
      child: TextField(
        controller: controller,
        readOnly: isReadOnly,
        style: TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Color(0xFFBDC3C7)), // Light gray label
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400]),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          suffixIcon: actionButton,
        ),
      ),
    );
  }

  // Method to build action buttons
  Widget _buildActionButton(String label, Function() onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF2980B9), // Formal blue button color
        padding: EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 6,
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
