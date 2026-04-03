import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/assessment_model.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';

class FirebaseService {
  static FirebaseService? _instance;
  static FirebaseService get instance => _instance ??= FirebaseService._();
  FirebaseService._();

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  // ── Auth ──────────────────────────────────────────────────────────────────

  Stream<User?> get authState => _auth.authStateChanges();

  Future<UserCredential> signInAnonymously() => _auth.signInAnonymously();

  Future<UserCredential> signInWithEmail(String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  Future<UserCredential> signUpWithEmail(String email, String password) =>
      _auth.createUserWithEmailAndPassword(email: email, password: password);

  Future<void> signOut() => _auth.signOut();

  // ── Profile ───────────────────────────────────────────────────────────────

  Future<void> saveProfile(UserProfile profile) async {
    final uid = _uid;
    if (uid == null) return;
    await _db
        .collection(AppConstants.usersCol)
        .doc(uid)
        .set(profile.toMap(), SetOptions(merge: true));
  }

  Future<UserProfile?> getProfile() async {
    final uid = _uid;
    if (uid == null) return null;
    final doc = await _db.collection(AppConstants.usersCol).doc(uid).get();
    if (!doc.exists) return null;
    return UserProfile.fromMap({...doc.data()!, 'uid': uid});
  }

  // ── Assessments ───────────────────────────────────────────────────────────

  Future<void> saveAssessment(Assessment a) async {
    final uid = _uid;
    if (uid == null) return;
    final map = a.toMap();
    map['timestamp'] = FieldValue.serverTimestamp();
    await _db
        .collection(AppConstants.usersCol)
        .doc(uid)
        .collection(AppConstants.assessmentsCol)
        .doc(a.id)
        .set(map);
  }

  Stream<List<Assessment>> assessmentsStream() {
    final uid = _uid;
    if (uid == null) return const Stream.empty();
    return _db
        .collection(AppConstants.usersCol)
        .doc(uid)
        .collection(AppConstants.assessmentsCol)
        .orderBy('timestamp', descending: true)
        .limit(100)
        .snapshots()
        .map((snap) => snap.docs.map((d) {
              final data = d.data();
              final ts = data['timestamp'];
              if (ts is Timestamp) {
                data['timestamp'] = ts.toDate().toIso8601String();
              }
              return Assessment.fromMap({...data, 'id': d.id});
            }).toList());
  }

  Future<void> markResolved(String assessmentId) async {
    final uid = _uid;
    if (uid == null) return;
    await _db
        .collection(AppConstants.usersCol)
        .doc(uid)
        .collection(AppConstants.assessmentsCol)
        .doc(assessmentId)
        .update({'resolved': true});
  }
}
