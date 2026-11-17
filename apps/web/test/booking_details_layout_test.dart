import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:util/util.dart';
import 'package:website/core/widgets/footer_widget.dart';
import 'package:website/features/auth/controller/auth_controller.dart';
import 'package:website/features/booking/presentations/booking_details_screen.dart';
import 'package:website/features/booking/provider/booking_provider.dart';

class _FakeParticipantRepository implements ParticipantRepository {
  final _participants = Stream.value(<UserModel>[]).asBroadcastStream();

  @override
  Stream<List<UserModel>> getAllParticipants(String bookingId) => _participants;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _HostNotifier extends UserNotifier {
  @override
  AsyncValue<UserModel?> build() => AsyncValue.data(
    UserModel(
      name: 'Ling Siew Woei',
      uid: 'host-1',
      email: 'host@example.com',
      createdAt: DateTime(2026, 11, 17),
      roles: {OrganizationsID.elShaddai.name: UserRole.intercessor},
    ),
  );
}

class _OrganizationController extends OrganizationController {
  @override
  Future<OrganizationsID> build() async => OrganizationsID.elShaddai;
}

const _longTitle =
    'SCHOOL OF THE SPIRIT - SPECIAL ONE-TIME SESSION - UNDERSTANDING '
    'THE LIFE OF GOD IN EVERY BORN-AGAIN BELIEVER';

Widget _buildTestApp() {
  final booking = BookingModel(
    id: 'booking-1',
    title: _longTitle,
    recurrenceState: RecurrenceState.none,
    host: 'Ling Siew Woei',
    createdAt: DateTime(2026, 11, 17),
    timeRange: CustomDateTimeRange(
      start: DateTime(2026, 11, 17, 20),
      end: DateTime(2026, 11, 17, 21, 30),
    ),
    userId: 'host-1',
    location: LocationData(address: null, web: 'https://zoom.us/j/5873767881'),
    description: List.filled(20, 'Pray for local churches.').join('\n'),
  );

  return ProviderScope(
    overrides: [
      userProvider.overrideWith(_HostNotifier.new),
      organizationControllerProvider.overrideWith(_OrganizationController.new),
      getSingleCurrentOrgBookingStreamProvider(
        bookingId: booking.id,
      ).overrideWithValue(AsyncValue.data(booking)),
      participantRepositoryProvider.overrideWithValue(
        _FakeParticipantRepository(),
      ),
    ],
    child: MaterialApp(
      theme: ThemeData(colorScheme: MaterialTheme.darkScheme()),
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
  );
}

void main() {
  for (final width in [390.0, 800.0, 1131.0, 1440.0]) {
    testWidgets('contains long title and scrolls on a $width x 350 screen', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 350);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(_buildTestApp());
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));

      expect(tester.takeException(), isNull);
      expect(find.text('Intercessor'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);

      final titleRect = tester.getRect(find.text(_longTitle));
      final shareRect = tester.getRect(find.byType(IconButton));
      final detailsRect = tester.getRect(
        find.byKey(const ValueKey('main_details_column')),
      );
      expect(titleRect.right, lessThanOrEqualTo(shareRect.left));
      expect(shareRect.right, lessThanOrEqualTo(detailsRect.right));

      final listView = find.byType(ListView);
      expect(listView, findsOneWidget);
      final scrollable = find
          .descendant(of: listView, matching: find.byType(Scrollable))
          .first;
      final position = tester.state<ScrollableState>(scrollable).position;
      expect(position.maxScrollExtent, greaterThan(0));

      position.jumpTo(position.maxScrollExtent);
      await tester.pump();

      final footerRect = tester.getRect(find.byType(FooterWidget));
      expect(footerRect.top, greaterThanOrEqualTo(0));
      expect(footerRect.bottom, closeTo(350, 0.1));
      expect(tester.takeException(), isNull);
    });
  }
}
