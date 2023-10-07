import 'package:flutter/material.dart';

/// A wrapper widget around `FutureBuilder` that displays a loading bar while
/// waiting for a future to complete, or error message if the future completes
/// with an error.
///
/// The widget takes a `Future` and a `(BuildContext, T) builderWithData`
/// function that returns a widget to display when the future completes
/// successfully.
///
class FutureBuilderWithLoadingBar<T> extends StatelessWidget {
  const FutureBuilderWithLoadingBar({
    required this.future,
    required this.builderWithData,
    super.key,
  });
  final Future<T> future;
  final Widget Function(BuildContext, T) builderWithData;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Text('None');
          case ConnectionState.waiting:
          case ConnectionState.active:
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              return builderWithData(context, snapshot.requireData);
            }
        }
      },
    );
  }
}
