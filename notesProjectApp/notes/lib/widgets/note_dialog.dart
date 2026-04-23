import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes/models/note.dart';
import 'package:notes/services/note_services.dart';
import 'package:url_launcher/url_launcher.dart';

class NoteDialog extends StatefulWidget {
  final Note? note;
  const NoteDialog({super.key, this.note});
  @override
  State<NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<NoteDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _imageFile;
  String? _base64Image;
  String? _latitude;
  String? _longtitude;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _descriptionController.text = widget.note!.title;
      _base64Image = widget.note!.imageBase64;
      _latitude = widget.note!.latitude;
      _longtitude = widget.note!.longtitude;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      String base64String = base64Encode(bytes);
      setState(() {
        _base64Image = base64String;
        // _imageFile= File(pickedFile.path);
      });
      print("Based64 String: $base64String");
    } else {
      print("No Image Selected");
    }
  }

  Future<void> _getLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Layanan lokasi dinonaktifkan.')),
        );
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever ||
            permission == LocationPermission.denied) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Izin lokasi ditolak.')));
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
      ).timeout(const Duration(seconds: 10));

      setState(() {
        _latitude = position.latitude.toString();
        _longtitude = position.longitude.toString();
      });
    } catch (e) {
      debugPrint('Failed to services location: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mengambil lokasi.')));
      setState(() {
        _latitude = null;
        _longtitude = null;
      });
    }
  }

  Future<void> openMap() async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${_latitude},${_longtitude}',
    );
    final success = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!mounted) return;
    if (!success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal Membukan peta')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.note == null ? 'add Notes' : 'update Notes'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Title: ', textAlign: TextAlign.start),
          TextField(controller: _titleController),
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text('Description: '),
          ),
          TextField(controller: _descriptionController),
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text('Image: '),
          ),

          Expanded(
            child: _base64Image != null
                ? Image.memory(
                    base64Decode(_base64Image!),
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                  )
                : Center(
                    child: Icon(
                      Icons.add_a_photo,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
          ),

          TextButton(onPressed: _pickImage, child: const Text('Pick Image')),
          TextButton(
            onPressed: _getLocation,
            child: const Text('Get Current Location'),
          ),
          if (_latitude != null && _longtitude != null)
            Text('Location: ($_latitude, $_longtitude)'),
          if (_latitude != null && _longtitude != null)
            TextButton(onPressed: openMap, child: const Text('Open in Maps')),
        ],
      ),

      actions: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ),

        ElevatedButton(
          onPressed: () {
            if (widget.note == null) {
              NoteServices.addNote(
                Note(
                  title: _titleController.text,
                  description: _descriptionController.text,
                  imageBase64: _base64Image,
                  latitude: _latitude,
                  longtitude: _longtitude,
                ),
              ).whenComplete(() {
                Navigator.of(context).pop();
              });
            } else {
              NoteServices.updateNote(
                Note(
                  id: widget.note!.id,
                  title: _titleController.text,
                  description: _descriptionController.text,
                  createdAt: widget.note!.createdAt,
                  imageBase64: _base64Image,
                  latitude: _latitude,
                  longtitude: _longtitude
                ),
              ).whenComplete(() => Navigator.of(context).pop());
            }
          },
          child: Text(widget.note == null ? 'Add' : 'Update'),
        ),
      ],
    );
  }
}
