import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:field_flow/db/firestore_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'firestore_helper_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  FirebaseAuth,
  CollectionReference,
  QuerySnapshot,
  QueryDocumentSnapshot,
  DocumentReference,
  DocumentSnapshot,
  User,
])
void main() {
  late FirestoreHelper firestoreHelper;
  late MockFirebaseFirestore mockFirestore;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockCollectionReference<Map<String, dynamic>> mockUsersCollection;
  late MockQuerySnapshot<Map<String, dynamic>> mockQuerySnapshot;
  late MockQueryDocumentSnapshot<Map<String, dynamic>>
      mockQueryDocumentSnapshot1;
  late MockQueryDocumentSnapshot<Map<String, dynamic>>
      mockQueryDocumentSnapshot2;
  late MockDocumentReference<Map<String, dynamic>> mockUserDocRef;
  late MockDocumentReference<Map<String, dynamic>> mockCheckInDocRef;
  late MockCollectionReference<Map<String, dynamic>> mockCheckEntriesCollection;
  late MockDocumentSnapshot<Map<String, dynamic>> mockUserDoc;
  late MockUser mockUser;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockFirebaseAuth = MockFirebaseAuth();
    mockUsersCollection = MockCollectionReference<Map<String, dynamic>>();
    mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();
    mockQueryDocumentSnapshot1 =
        MockQueryDocumentSnapshot<Map<String, dynamic>>();
    mockQueryDocumentSnapshot2 =
        MockQueryDocumentSnapshot<Map<String, dynamic>>();
    mockUser = MockUser();
    mockUserDocRef = MockDocumentReference<Map<String, dynamic>>();
    mockCheckInDocRef = MockDocumentReference<Map<String, dynamic>>();
    mockUsersCollection = MockCollectionReference<Map<String, dynamic>>();
    mockCheckEntriesCollection = MockCollectionReference<Map<String, dynamic>>();
    mockUserDoc = MockDocumentSnapshot<Map<String, dynamic>>();

    firestoreHelper =
        FirestoreHelper(firestore: mockFirestore, auth: mockFirebaseAuth);
  });

  test('getUsers() fetches users from Firestore and returns a mapped list',
      () async {
    when(mockFirestore.collection('users')).thenReturn(mockUsersCollection);

    when(mockUsersCollection.get()).thenAnswer((_) async => mockQuerySnapshot);

    when(mockQuerySnapshot.docs).thenReturn([
      mockQueryDocumentSnapshot1,
      mockQueryDocumentSnapshot2,
    ]);

    when(mockQueryDocumentSnapshot1.id).thenReturn('user1');
    when(mockQueryDocumentSnapshot2.id).thenReturn('user2');

    when(mockQueryDocumentSnapshot1.data()).thenReturn({'name': 'Q'});
    when(mockQueryDocumentSnapshot2.data()).thenReturn({'name': 'Anthony'});

    when(mockQueryDocumentSnapshot1['name']).thenReturn('Q');
    when(mockQueryDocumentSnapshot2['name']).thenReturn('Anthony');

    // Call
    final result = await firestoreHelper.getUsers();

    // Verify
    expect(result, {
      'user1': 'Q',
      'user2': 'Anthony',
    });
    verify(mockFirestore.collection('users')).called(1);
    verify(mockUsersCollection.get()).called(1);
  });

  test('fetchUsers() fetches users from Firestore and returns a list of maps',
      () async {
    when(mockFirestore.collection('users')).thenReturn(mockUsersCollection);

    when(mockUsersCollection.get()).thenAnswer((_) async => mockQuerySnapshot);

    when(mockQuerySnapshot.docs).thenReturn([
      mockQueryDocumentSnapshot1,
      mockQueryDocumentSnapshot2,
    ]);

    when(mockQueryDocumentSnapshot1.id).thenReturn('user1');
    when(mockQueryDocumentSnapshot2.id).thenReturn('user2');

    when(mockQueryDocumentSnapshot1.data()).thenReturn({'name': 'Q'});
    when(mockQueryDocumentSnapshot2.data()).thenReturn({'name': 'Anthony'});

    when(mockQueryDocumentSnapshot1['name']).thenReturn('Q');
    when(mockQueryDocumentSnapshot2['name']).thenReturn('Anthony');

    // Call
    final result = await firestoreHelper.fetchUsers();

    // Verify
    expect(result, [
      {'id': 'user1', 'name': 'Q'},
      {'id': 'user2', 'name': 'Anthony'},
    ]);
    verify(mockFirestore.collection('users')).called(1);
    verify(mockUsersCollection.get()).called(1);
  });

  test('getUser() retrieves a user document from Firestore', () async {
    final mockUserDocRef = MockDocumentReference<Map<String, dynamic>>();
    final mockUserSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();

    when(mockFirestore.collection('users')).thenReturn(mockUsersCollection);
    when(mockUsersCollection.doc('user1')).thenReturn(mockUserDocRef);
    when(mockUserDocRef.get()).thenAnswer((_) async => mockUserSnapshot);

    // Call
    final result = await firestoreHelper.getUser('user1');

    // Verify
    expect(result, mockUserSnapshot);
    verify(mockFirestore.collection('users')).called(1);
    verify(mockUsersCollection.doc('user1')).called(1);
    verify(mockUserDocRef.get()).called(1);
  });

  test('createUser() adds a new user to Firestore', () async {
    final mockUserDocRef = MockDocumentReference<Map<String, dynamic>>();

    when(mockFirestore.collection('users')).thenReturn(mockUsersCollection);
    when(mockUsersCollection.doc('user1')).thenReturn(mockUserDocRef);
    when(mockUserDocRef.set(any)).thenAnswer((_) async => {});

    // Call
    await firestoreHelper.createUser('user1', 'Q', 'Q@example.com');

    // Verify
    verify(mockFirestore.collection('users')).called(1);
    verify(mockUsersCollection.doc('user1')).called(1);
    verify(mockUserDocRef.set({
      'name': 'Q',
      'email': 'Q@example.com',
      'role': null,
    })).called(1);
  });

  test('saveCheckIn() saves a check-in entry and returns the document ID', () async {
    final mockUser = MockUser();
    final mockUserDoc = MockDocumentSnapshot<Map<String, dynamic>>();
    final mockCheckInDocRef = MockDocumentReference<Map<String, dynamic>>();
    // Set up
    when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
    when(mockUser.uid).thenReturn('mockUserId');
    when(mockFirestore.collection('users')).thenReturn(mockUsersCollection);
    when(mockUsersCollection.doc('mockUserId')).thenReturn(mockUserDocRef);
    when(mockUserDocRef.get()).thenAnswer((_) async => mockUserDoc);
    when(mockUserDoc['role']).thenReturn('worker'); // Simulating role retrieval
    when(mockFirestore.collection('check_entries')).thenReturn(mockCheckEntriesCollection);
    when(mockCheckEntriesCollection.doc()).thenReturn(mockCheckInDocRef);
    when(mockCheckInDocRef.id).thenReturn('mockCheckInId');
    when(mockCheckInDocRef.set(any)).thenAnswer((_) async {});

    // Call
    final checkInTime = DateTime(2025, 3, 10, 8, 0, 0);
    final result = await firestoreHelper.saveCheckIn(checkInTime);

    // Verify
    expect(result, 'mockCheckInId');
    verify(mockFirestore.collection('users')).called(1);
    verify(mockUsersCollection.doc('mockUserId')).called(1);
    verify(mockUserDocRef.get()).called(1);
    verify(mockFirestore.collection('check_entries')).called(1);
    verify(mockCheckEntriesCollection.doc()).called(1);
    verify(mockCheckInDocRef.set({
      'userId': 'mockUserId',
      'role': 'worker',
      'checkInTime': checkInTime.toIso8601String(),
      'checkedIn': true,
      'checkedOut': false,
      'locations': [],
    })).called(1);
  });

}
