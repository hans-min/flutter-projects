import 'package:flutter/material.dart';
import 'package:myoty/components/date_time_rich_text.dart';

class MapSearchBar extends StatefulWidget {
  const MapSearchBar({
    required this.onSubmitted,
    super.key,
  });
  final void Function(String) onSubmitted;

  @override
  State<MapSearchBar> createState() => _MapSearchBarState();
}

class _MapSearchBarState extends State<MapSearchBar> {
  final textController = TextEditingController();

//why is this widget being rebuilt ? Because it was a stateless widget
// which means it will be rebuilt everytime the parent widget is rebuilt,
// which I discovered by adding a TextController, which was being reset
// everytime I submitted the search bar

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 10),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                controller: textController,
                onSubmitted: widget.onSubmitted,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.search),
                  constraints: const BoxConstraints(
                    maxHeight: 36,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            popupButton(),
          ],
        ),
      ),
    );
  }

  PopupMenuButton<PopUpAction> popupButton() {
    final color = Theme.of(context).colorScheme.primary;
    return PopupMenuButton<PopUpAction>(
      icon: Icon(Icons.more_vert, color: color),
      onSelected: (value) {
        switch (value) {
          case PopUpAction.refresh:
            widget.onSubmitted(textController.text);
          case PopUpAction.planView:
            //TODO: change to plan view
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: PopUpAction.refresh,
          child: RichTextSpan(
            leading: Icon(Icons.refresh, color: color),
            text: "Refresh",
          ),
        ),
        PopupMenuItem(
          value: PopUpAction.planView,
          child: RichTextSpan(
            text: "Plan View",
            leading: Icon(Icons.map, color: color),
          ),
        ),
      ],
    );
  }
}

enum PopUpAction { refresh, planView }
