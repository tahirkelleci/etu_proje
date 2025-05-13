
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'models/events.dart';
import 'models/announcement.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore;

  FirebaseService()
      : _firestore = FirebaseFirestore.instanceFor(
          app: Firebase.app(),
          databaseId: 'etubmdb',
        );

  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;
      final snapshot = await _firestore.collection('users').doc(user.uid).get();
      return snapshot.exists ? snapshot.data() as Map<String, dynamic> : null;
    } catch (e) {
      print('Error fetching profile: $e');
      return null;
    }
  }

  Future<void> updateUserProfile(Map<String, dynamic> data) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(data, SetOptions(merge: true));
    } catch (e) {
      print('Error updating profile: $e');
    }
  }

  Future<List<Events>> getEvents() async {
    try {
      final snapshot = await _firestore.collection('events').get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Events.fromFirestore(data, doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching events: $e');
      return [];
    }
  }

  Future<List<Announcement>> getAnnouncements() async {
    try {
      final snapshot = await _firestore.collection('announcement').get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Announcement.fromFirestore(data, doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching announcements: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getUserEvents() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;
      final doc = await _firestore.collection('fevori').doc(user.email).get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      print('Error fetching user events: $e');
      return null;
    }
  }

  Future<void> updateProfileImage(String imageUrl) async {
    final uid = _auth.currentUser!.uid;
    await _firestore.collection('users').doc(uid).update({
      'profileImage': imageUrl,
    });
  }

  Future<List<String>> getRingServices() async {
    try {
      final snap = await _firestore.collection('ring').get();
      if (snap.docs.isEmpty) return [];
      final data = snap.docs.first.data() as Map<String, dynamic>;
      return List<String>.generate(7, (i) {
        final key = 'ServicesInfo_${i + 1}';
        return data[key] as String? ?? '';
      });
    } catch (e) {
      print('Error fetching ring services: $e');
      return [];
    }
  }

  /// Firestore'daki "transkript" koleksiyonundan ham map listesi döner.
  Future<List<Map<String, dynamic>>> getTranskriptEntries() async {
    final snapshot = await _firestore.collection('transkript').get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<void> toggleEventLike(String eventId) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return;

      DocumentReference eventRef = _firestore.collection('events').doc(eventId);

      // Get current event data
      DocumentSnapshot eventDoc = await eventRef.get();
      if (!eventDoc.exists) return;

      Map<String, dynamic> data = eventDoc.data() as Map<String, dynamic>;
      List<String> likedBy = List<String>.from(data['likedBy'] ?? []);

      // Toggle like
      if (likedBy.contains(user.uid)) {
        likedBy.remove(user.uid);
      } else {
        likedBy.add(user.uid);
      }

      // Update the event
      await eventRef.update({
        'likedBy': likedBy,
      });
    } catch (e) {
      print('Error toggling event like: $e');
    }
  }

  Future<bool> isEventLiked(String eventId) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return false;

      DocumentSnapshot eventDoc =
          await _firestore.collection('events').doc(eventId).get();
      if (!eventDoc.exists) return false;

      Map<String, dynamic> data = eventDoc.data() as Map<String, dynamic>;
      List<String> likedBy = List<String>.from(data['likedBy'] ?? []);

      return likedBy.contains(user.uid);
    } catch (e) {
      print('Error checking if event is liked: $e');
      return false;
    }
  }

  Future<void> toggleEventParticipation(String eventId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final docRef = _firestore.collection('events').doc(eventId);

    final docSnapshot = await docRef.get();
    if (!docSnapshot.exists) return;

    final data = docSnapshot.data() as Map<String, dynamic>;
    List<String> participants = List<String>.from(data['participants'] ?? []);

    if (participants.contains(uid)) {
      participants.remove(uid);
    } else {
      participants.add(uid);
    }

    await docRef.update({'participants': participants});
  }

  Future<List<Map<String, dynamic>>> getLikedEvents(String uid) async {
    try {
      final snapshot = await _firestore
          .collection('events')
          .where('likedBy', arrayContains: uid)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error fetching liked events: $e');
      return [];
    }
  }

  Future<bool> isEventParticipant(String eventId) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return false;

      DocumentSnapshot eventDoc =
          await _firestore.collection('events').doc(eventId).get();
      if (!eventDoc.exists) return false;

      Map<String, dynamic> data = eventDoc.data() as Map<String, dynamic>;
      List<String> participants = List<String>.from(data['participants'] ?? []);

      return participants.contains(user.uid);
    } catch (e) {
      print('Error checking if user is participant: $e');
      return false;
    }
  }

  Future<void> anketResponse(
      String surveyType, Map<String, dynamic> responses) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print("User is not authenticated");
        return;
      }

      final docRef = _firestore.collection('Anket').doc(user.uid);

      final docSnapshot = await docRef.get();

      if (docSnapshot.exists && docSnapshot.data()!.containsKey(surveyType)) {
        throw Exception("Bu anket daha önce doldurulmuş.");
      }

      await docRef.set({
        surveyType: {
          'email': user.email,
          'responses': responses,
          'submittedAt': FieldValue.serverTimestamp(),
        },
      }, SetOptions(merge: true));

      print("Survey responses submitted successfully.");
    } catch (e) {
      print('Error submitting survey response: $e');
      throw e;
    }
  }

  Future<void> removeLikedEvent(String eventId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final eventRef = _firestore.collection('events').doc(eventId);
    await eventRef.update({
      'likedBy': FieldValue.arrayRemove([uid]),
    });
  }

  Future<List<Map<String, dynamic>>> getAttendingEvents(String uid) async {
    try {
      final snapshot = await _firestore.collection('events').get();

      final attendingEvents = snapshot.docs.where((doc) {
        final data = doc.data();
        final participants = List<String>.from(data['participants'] ?? []);
        return participants.contains(uid);
      }).map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'title': data['title'] ?? '',
          'subtitle': data['publisher'] ?? '',
          'imageUrl': data['image'] ?? '',
        };
      }).toList();

      return attendingEvents;
    } catch (e) {
      print('Error fetching attending events: $e');
      return [];
    }
  }
}
