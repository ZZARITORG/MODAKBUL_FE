import 'package:flutter/material.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/widgets/modakbul_detail_card.dart';

class ModakbulDetailScreen extends StatefulWidget {
  const ModakbulDetailScreen({super.key});

  @override
  State<ModakbulDetailScreen> createState() => _ModakbulDetailScreenState();
}

class _ModakbulDetailScreenState extends State<ModakbulDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: BackButtonAppBar(),
      body: Column(
        children: [
            ModakbulDetailCard(userName: 'userName', userId: 'userId', posterProfileImage: 'posterProfileImage', profileLength: 4, participantProfileImage: 'participantProfileImage')
        ],
      ),
    );
  }
}
