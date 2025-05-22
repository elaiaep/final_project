import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../widgets/reusable_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  File? _imageFile;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isEditing = false;
  String _name = '';
  String _phone = '';

  @override
  void initState() {
    super.initState();
    _name = user?.displayName ?? 'Not set';
    _nameController.text = _name;
    _phoneController.text = _phone;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      // TODO: Implement image upload to Firebase Storage
    }
  }

  Future<void> _saveUserInfo() async {
    setState(() {
      _name = _nameController.text;
      _phone = _phoneController.text;
      _isEditing = false;
    });
    
    try {
      if (user != null) {
        await user!.updateDisplayName(_name);
        // You might want to save phone number to your backend/Firestore here
      }
    } catch (e) {
      debugPrint('Error updating user info: $e');
    }
  }

  Widget _buildProfileImage() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: _imageFile != null
              ? FileImage(_imageFile!)
              : (user?.photoURL != null
                  ? NetworkImage(user!.photoURL!) as ImageProvider
                  : const AssetImage('assets/images/default_avatar.jpg')),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.camera_alt, color: Colors.white),
              onPressed: _pickImage,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile(String title, String value, {bool isEditable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ListTile(
          title: Text(title,
              style: TextStyle(color: Theme.of(context).primaryColor)),
          subtitle: _isEditing && isEditable
              ? TextField(
                  controller: title == 'Name'
                      ? _nameController
                      : title == 'Phone'
                          ? _phoneController
                          : null,
                  decoration: InputDecoration(
                    hintText: 'Enter your ${title.toLowerCase()}',
                  ),
                )
              : Text(title == 'Name' ? _name : (title == 'Phone' ? _phone : value)),
          trailing: isEditable
              ? IconButton(
                  icon: Icon(_isEditing ? Icons.check : Icons.edit),
                  onPressed: () {
                    if (_isEditing) {
                      _saveUserInfo();
                    } else {
                      setState(() {
                        _isEditing = true;
                      });
                    }
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Settings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.shopping_bag),
          title: const Text('Order History'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            // TODO: Navigate to order history
          },
        ),
        ListTile(
          leading: const Icon(Icons.notifications),
          title: const Text('Notifications'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            // TODO: Navigate to notifications settings
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildProfileImage(),
                  const SizedBox(height: 24),
                  Text(
                    _name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user?.email ?? '',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildInfoTile('Name', _name, isEditable: true),
                  _buildInfoTile('Email', user?.email ?? 'Not set'),
                  _buildInfoTile('Phone', _phone, isEditable: true),
                ],
              ),
            ),
            const Divider(),
            _buildSettingsSection(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: AnimatedActionButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (mounted) {
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                },
                color: Colors.red,
                child: const Text("Sign Out"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}