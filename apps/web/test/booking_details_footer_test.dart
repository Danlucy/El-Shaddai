import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:util/util.dart';
import 'package:website/core/widgets/footer_widget.dart';
import 'package:website/features/booking/presentations/booking_details_screen.dart';
import 'package:website/features/booking/provider/booking_provider.dart';

class _FakeParticipantRepository implements ParticipantRepository {
  @override
  Stream<List<UserModel>> getAllParticipants(String bookingId) =>
      const Stream.empty();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

BookingModel _sampleBooking({String description = 'Pray for local churches'}) {
  return BookingModel(
    id: 'booking-1',
    title: 'Prayer Watch',
    recurrenceState: RecurrenceState.none,
    host: 'Pr Thomas hp1',
    createdAt: DateTime(2026, 11, 16),
    timeRange: CustomDateTimeRange(
      start: DateTime(2026, 11, 16, 16, 55),
      end: DateTime(2026, 11, 16, 19, 30),
    ),
    userId: 'user-1',
    location: LocationData(address: null),
    description: description,
  );
}

Widget _buildTestApp({
  required AsyncValue<BookingModel?> bookingState,
  Size viewportSize = const Size(1200, 1000),
}) {
  return ProviderScope(
    overrides: [
      getSingleCurrentOrgBookingStreamProvider(bookingId: 'booking-1')
          .overrideWithValue(bookingState),
      participantRepositoryProvider.overrideWithValue(
        _FakeParticipantRepository(),
      ),
    ],
    child: MediaQuery(
      data: MediaQueryData(size: viewportSize),
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: MaterialTheme.darkScheme(),
        ),
        builder: (context, child) => ResponsiveBreakpoints.builder(
          breakpoints: const [
            Breakpoint(start: 0, end: 450, name: MOBILE),
            Breakpoint(start: 451, end: 800, name: TABLET),
            Breakpoint(start: 801, end: 1920, name: DESKTOP),
            Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
          child: child!,
        ),
        home: const BookingDetailsScreen(bookingId: 'booking-1'),
      ),
    ),
  );
}

void main() {
  testWidgets(
    'pins FooterWidget to bottom of viewport when booking content is short',
    (tester) async {
      tester.view.physicalSize = const Size(1200, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _buildTestApp(bookingState: AsyncValue.data(_sampleBooking())),
      );
      await tester.pump();

      final footerFinder = find.byType(FooterWidget);
      expect(footerFinder, findsOneWidget);

      final footerRect = tester.getRect(footerFinder);
      expect(footerRect.bottom, closeTo(1000.0, 0.1));
      expect(footerRect.width, closeTo(1200.0, 0.1));
    },
  );

  testWidgets(
    'pins FooterWidget to bottom of viewport when booking is not found',
    (tester) async {
      tester.view.physicalSize = const Size(1200, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _buildTestApp(bookingState: const AsyncValue.data(null)),
      );
      await tester.pump();

      expect(find.text('Booking not found.'), findsOneWidget);
      final footerRect = tester.getRect(find.byType(FooterWidget));
      expect(footerRect.bottom, closeTo(1000.0, 0.1));
      expect(footerRect.width, closeTo(1200.0, 0.1));
    },
  );

  testWidgets(
    'pins FooterWidget to bottom of viewport on error',
    (tester) async {
      tester.view.physicalSize = const Size(1200, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _buildTestApp(
          bookingState: AsyncValue.error(Exception('boom'), StackTrace.empty),
        ),
      );
      await tester.pump();

      expect(find.text('Failed to load booking details.'), findsOneWidget);
      final footerRect = tester.getRect(find.byType(FooterWidget));
      expect(footerRect.bottom, closeTo(1000.0, 0.1));
      expect(footerRect.width, closeTo(1200.0, 0.1));
    },
  );

  testWidgets(
    'places FooterWidget below content when viewport is shorter than content',
    (tester) async {
      tester.view.physicalSize = const Size(1200, 350);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _buildTestApp(
          bookingState: AsyncValue.data(
            _sampleBooking(
              description: List.filled(20, 'Pray for local churches.').join('\n'),
            ),
          ),
          viewportSize: const Size(1200, 350),
        ),
      );
      await tester.pump();

      final footerFinder = find.byType(FooterWidget);
      await tester.scrollUntilVisible(
        footerFinder,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pump();

      expect(footerFinder, findsOneWidget);
      final footerRect = tester.getRect(footerFinder);
      expect(footerRect.bottom, lessThanOrEqualTo(350.0));
      expect(footerRect.width, closeTo(1200.0, 0.1));
    },
  );
}
