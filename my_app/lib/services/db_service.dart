import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/post.dart';
import '../models/event.dart';
import '../models/user.dart';

class DBService {
  static final DBService _instance = DBService._internal();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  factory DBService() {
    return _instance;
  }

  DBService._internal();

  // ==================== User Operations ====================

  /// Save user data to Firestore
  Future<bool> saveUser(User user) async {
    try {
      await _firestore.collection('users').doc(user.id).set({
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      debugPrint('Save user error: $e');
      return false;
    }
  }

  /// Get user data
  Future<User?> getUser(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return User.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      debugPrint('Get user error: $e');
      return null;
    }
  }

  // ==================== Post Operations ====================

  /// Create a post
  Future<bool> createPost(Post post) async {
    try {
      await _firestore.collection('posts').doc(post.id).set({
        'id': post.id,
        'title': post.title,
        'content': post.content,
        'authorId': post.authorId,
        'createdAt': post.createdAt.toIso8601String(),
      });
      return true;
    } catch (e) {
      debugPrint('Create post error: $e');
      return false;
    }
  }

  /// Get all posts
  Future<List<Post>> getPosts() async {
    try {
      final snapshot = await _firestore
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs.map((doc) => Post.fromJson(doc.data())).toList();
    } catch (e) {
      debugPrint('Get posts error: $e');
      return [];
    }
  }

  /// Get posts by author
  Future<List<Post>> getPostsByAuthor(String authorId) async {
    try {
      final snapshot = await _firestore
          .collection('posts')
          .where('authorId', isEqualTo: authorId)
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs.map((doc) => Post.fromJson(doc.data())).toList();
    } catch (e) {
      debugPrint('Get posts by author error: $e');
      return [];
    }
  }

  /// Update post
  Future<bool> updatePost(Post post) async {
    try {
      await _firestore.collection('posts').doc(post.id).update({
        'title': post.title,
        'content': post.content,
      });
      return true;
    } catch (e) {
      debugPrint('Update post error: $e');
      return false;
    }
  }

  /// Delete post
  Future<bool> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
      return true;
    } catch (e) {
      debugPrint('Delete post error: $e');
      return false;
    }
  }

  // ==================== Event Operations ====================

  /// Create an event
  Future<bool> createEvent(Event event) async {
    try {
      await _firestore.collection('events').doc(event.id).set({
        'id': event.id,
        'title': event.title,
        'description': event.description,
        'date': event.date.toIso8601String(),
      });
      return true;
    } catch (e) {
      debugPrint('Create event error: $e');
      return false;
    }
  }

  /// Get all events
  Future<List<Event>> getEvents() async {
    try {
      final snapshot = await _firestore
          .collection('events')
          .orderBy('date', descending: false)
          .get();
      return snapshot.docs.map((doc) => Event.fromJson(doc.data())).toList();
    } catch (e) {
      debugPrint('Get events error: $e');
      return [];
    }
  }

  /// Get events by date range
  Future<List<Event>> getEventsByDateRange(DateTime start, DateTime end) async {
    try {
      final snapshot = await _firestore
          .collection('events')
          .where('date', isGreaterThanOrEqualTo: start.toIso8601String())
          .where('date', isLessThanOrEqualTo: end.toIso8601String())
          .orderBy('date', descending: false)
          .get();
      return snapshot.docs.map((doc) => Event.fromJson(doc.data())).toList();
    } catch (e) {
      debugPrint('Get events by date range error: $e');
      return [];
    }
  }

  /// Update event
  Future<bool> updateEvent(Event event) async {
    try {
      await _firestore.collection('events').doc(event.id).update({
        'title': event.title,
        'description': event.description,
        'date': event.date.toIso8601String(),
      });
      return true;
    } catch (e) {
      debugPrint('Update event error: $e');
      return false;
    }
  }

  /// Delete event
  Future<bool> deleteEvent(String eventId) async {
    try {
      await _firestore.collection('events').doc(eventId).delete();
      return true;
    } catch (e) {
      debugPrint('Delete event error: $e');
      return false;
    }
  }
}