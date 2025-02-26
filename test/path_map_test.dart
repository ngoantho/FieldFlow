import 'package:field_flow/model/location_model.dart';
import 'package:field_flow/path_map/path_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'path_map_test.mocks.dart';
import 'package:mockito/annotations.dart';

// Generate a mock class for GoogleMapController
@GenerateMocks([GoogleMapController])
void main() {
  late MockGoogleMapController mockMapController;

  setUp(() {
    mockMapController = MockGoogleMapController();
  });

  testWidgets('Pathmap renders with markers and polylines', (tester) async {
    // Mock location data
    final List<LocationModel> mockLocations = [
      LocationModel(37.7749, -122.4194, Duration(minutes: 5)),
      LocationModel(37.7849, -122.4294, Duration(minutes: 10)),
      LocationModel(37.7949, -122.4394, Duration(minutes: 0)),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Pathmap(locationList: mockLocations),
      ),
    );

    await tester.pumpAndSettle(); // Wait for rendering

    expect(find.byType(Pathmap), findsOneWidget);
    expect(find.byType(GoogleMap), findsOneWidget);

  });
}