import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String? id;
  String? image;
  final String description;
  Timestamp? createdAt;
  Timestamp? updatedAt;
  String? category;
  String? latitude;
  String? longtitude;
  String? userId;
  String? userFullName;

  Post({
    this.id,
    this.image,
    required this.description,
    this.createdAt,
    this.updatedAt,
    this.category,
    this.latitude,
    this.longtitude,
    this.userId,
    this.userFullName,
  });

  factory Post.fromdocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Post(
      id: data['id'],
      image: data['image'],
      description: data['description'],
      createdAt: data['created_at'] as Timestamp,
      updatedAt: data['update_at'] as Timestamp,
      category: data['category'],
      latitude: data['latitude'],
      longtitude: data['longtitude'],
      userId: data['user_id'],
      userFullName: data['user_full_name'],
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'image': image,
      'description': description,
      'created_at': createdAt,
      'update_at': updatedAt,
      'category': category,
      'latitude': latitude,
      'longtitude': longtitude,
      'user_id': userId,
      'user_full_name': userFullName,
    };
  }
}
