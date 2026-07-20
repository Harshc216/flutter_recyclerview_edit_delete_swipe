import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_recyclerview_edit_delete_swipe/flutter_recyclerview_edit_delete_swipe.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: ListView(
          children: [child],
        ),
      ),
    );
  }

  testWidgets('renders child widget correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        SwipeActionTile(
          key: const Key('item_1'),
          child: const Text('Test Swipe Item'),
        ),
      ),
    );

    expect(find.text('Test Swipe Item'), findsOneWidget);
  });

  testWidgets('triggers onEdit callback when swiped right', (WidgetTester tester) async {
    bool editCalled = false;

    await tester.pumpWidget(
      buildTestableWidget(
        SwipeActionTile(
          key: const Key('item_2'),
          onEdit: () {
            editCalled = true;
          },
          child: const SizedBox(
            height: 100,
            width: double.infinity,
            child: Text('Swipe Me Right'),
          ),
        ),
      ),
    );

    expect(find.text('Swipe Me Right'), findsOneWidget);

    // Swipe right to edit
    await tester.drag(find.text('Swipe Me Right'), const Offset(500, 0));
    await tester.pumpAndSettle();

    expect(editCalled, isTrue);
  });

  testWidgets('triggers onDelete callback when swiped left', (WidgetTester tester) async {
    bool deleteCalled = false;

    await tester.pumpWidget(
      buildTestableWidget(
        SwipeActionTile(
          key: const Key('item_3'),
          onDelete: () {
            deleteCalled = true;
          },
          child: const SizedBox(
            height: 100,
            width: double.infinity,
            child: Text('Swipe Me Left'),
          ),
        ),
      ),
    );

    expect(find.text('Swipe Me Left'), findsOneWidget);

    // Swipe left to delete
    await tester.drag(find.text('Swipe Me Left'), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(deleteCalled, isTrue);
  });

  testWidgets('respects confirmDelete callback when swiped left', (WidgetTester tester) async {
    bool deleteCalled = false;
    bool confirmDeleteCalled = false;
    bool shouldDelete = false;

    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) {
          return buildTestableWidget(
            SwipeActionTile(
              key: const Key('item_4'),
              confirmDelete: () {
                confirmDeleteCalled = true;
                return shouldDelete;
              },
              onDelete: () {
                deleteCalled = true;
              },
              child: const SizedBox(
                height: 100,
                width: double.infinity,
                child: Text('Swipe Me Cancelable'),
              ),
            ),
          );
        },
      ),
    );

    // Swipe left with confirm returning false
    await tester.drag(find.text('Swipe Me Cancelable'), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(confirmDeleteCalled, isTrue);
    expect(deleteCalled, isFalse); // Should not delete because confirm returned false

    // Reset indicator and change confirm to return true
    confirmDeleteCalled = false;
    shouldDelete = true;

    // Swipe left with confirm returning true
    await tester.drag(find.text('Swipe Me Cancelable'), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(confirmDeleteCalled, isTrue);
    expect(deleteCalled, isTrue); // Should be delete because confirm returned true
  });

  testWidgets('triggers onArchive callback when swiped', (WidgetTester tester) async {
    bool archiveCalled = false;

    await tester.pumpWidget(
      buildTestableWidget(
        SwipeActionTile(
          key: const Key('item_archive_1'),
          onArchive: () {
            archiveCalled = true;
          },
          child: const SizedBox(
            height: 100,
            width: double.infinity,
            child: Text('Swipe Me To Archive'),
          ),
        ),
      ),
    );

    expect(find.text('Swipe Me To Archive'), findsOneWidget);

    // Swipe right to archive
    await tester.drag(find.text('Swipe Me To Archive'), const Offset(500, 0));
    await tester.pumpAndSettle();

    expect(archiveCalled, isTrue);
  });

  testWidgets('respects confirmArchive callback when swiped', (WidgetTester tester) async {
    bool archiveCalled = false;
    bool confirmArchiveCalled = false;
    bool shouldArchive = false;

    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) {
          return buildTestableWidget(
            SwipeActionTile(
              key: const Key('item_archive_2'),
              confirmArchive: () {
                confirmArchiveCalled = true;
                return shouldArchive;
              },
              onArchive: () {
                archiveCalled = true;
              },
              child: const SizedBox(
                height: 100,
                width: double.infinity,
                child: Text('Swipe Me Confirm Archive'),
              ),
            ),
          );
        },
      ),
    );

    // Swipe with confirm returning false
    await tester.drag(find.text('Swipe Me Confirm Archive'), const Offset(500, 0));
    await tester.pumpAndSettle();

    expect(confirmArchiveCalled, isTrue);
    expect(archiveCalled, isFalse);

    // Reset indicator and change confirm to return true
    confirmArchiveCalled = false;
    shouldArchive = true;

    // Swipe with confirm returning true
    await tester.drag(find.text('Swipe Me Confirm Archive'), const Offset(500, 0));
    await tester.pumpAndSettle();

    expect(confirmArchiveCalled, isTrue);
    expect(archiveCalled, isTrue);
  });
}
