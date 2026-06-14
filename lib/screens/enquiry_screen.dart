import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/recipe.dart';
import '../widgets/app_text_field.dart';

class EnquiryScreen extends StatefulWidget {
  final Recipe recipe;

  const EnquiryScreen({super.key, required this.recipe});

  @override
  State<EnquiryScreen> createState() => _EnquiryScreenState();
}

class _EnquiryScreenState extends State<EnquiryScreen> {
  static const String enquiryEmail = 'hardikmangs@gmail.com';

  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _message = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _sendEnquiry() async {
    if (!_formKey.currentState!.validate()) return;

    final subject = Uri.encodeComponent('Recipe Enquiry: ${widget.recipe.title}');
    final body = Uri.encodeComponent(
      'Name: ${_name.text.trim()}\n'
      'Email: ${_email.text.trim()}\n'
      'Recipe: ${widget.recipe.title}\n\n'
      'Message:\n${_message.text.trim()}',
    );

    final uri = Uri.parse('mailto:$enquiryEmail?subject=$subject&body=$body');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No email app found on this device')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recipe Enquiry')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.recipe.title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 18),
              AppTextField(
                controller: _name,
                label: 'Your Name',
                icon: Icons.person_outline,
                validator: (value) => value == null || value.trim().isEmpty ? 'Enter your name' : null,
              ),
              const SizedBox(height: 14),
              AppTextField(
                controller: _email,
                label: 'Your Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Enter email';
                  if (!value.contains('@')) return 'Enter valid email';
                  return null;
                },
              ),
              const SizedBox(height: 14),
              AppTextField(
                controller: _message,
                label: 'Message',
                icon: Icons.message_outlined,
                maxLines: 5,
                validator: (value) => value == null || value.trim().isEmpty ? 'Enter message' : null,
              ),
              const SizedBox(height: 22),
              ElevatedButton.icon(
                onPressed: _sendEnquiry,
                icon: const Icon(Icons.send),
                label: const Text('Send Enquiry Email'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
