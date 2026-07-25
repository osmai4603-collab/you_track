
import 'package:flutter/material.dart';

class YouTrackContentHeader extends StatefulWidget {
  const YouTrackContentHeader({super.key});

  @override
  State<YouTrackContentHeader> createState() => _YouTrackContentHeaderState();
}

class _YouTrackContentHeaderState extends State<YouTrackContentHeader> {

  @override
  Widget build(BuildContext context) {
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildIssues(),

      ],
    );
  }

  Container _buildIssues() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'YouTrack',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () {
                        // Handle settings button press
                      },
                    ),
                  ],
                ),
              ),
            ),
            _buildMenuIssusesButton(),
          ],
        ),
      );
  }
  
  Widget _buildMenuIssusesButton() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.menu),
      onSelected: (String value) {
        // Handle menu item selection
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'item1',
          child: Text('Item 1'),
        ),
        const PopupMenuItem<String>(
          value: 'item2',
          child: Text('Item 2'),
        ),
      ],
    );
  }
}