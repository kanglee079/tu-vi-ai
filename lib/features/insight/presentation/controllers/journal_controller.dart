import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/birth_profile.dart';
import '../../../../data/models/insight_models.dart';
import '../../../../data/repositories/chart_repository.dart';
import '../../../../data/repositories/insight_repository.dart';

class JournalController extends GetxController {
  JournalController(this._chartRepository, this._insightRepository);

  final ChartRepository _chartRepository;
  final InsightRepository _insightRepository;

  final TextEditingController noteController = TextEditingController();
  final Rx<JournalMood> selectedMood = JournalMood.deep.obs;
  final Rxn<BirthProfile> profile = Rxn<BirthProfile>();
  final Rxn<JournalReflection> reflection = Rxn<JournalReflection>();
  final RxList<JournalEntry> entries = <JournalEntry>[].obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    profile.value = await _chartRepository.getMainProfile();
    final resolvedProfile = profile.value;
    if (resolvedProfile == null) {
      return;
    }
    reflection.value = await _insightRepository.getLatestReflection(
      resolvedProfile.id,
    );
    entries.assignAll(
      await _insightRepository.listJournalEntries(resolvedProfile.id),
    );
  }

  Future<void> saveEntry() async {
    final text = noteController.text.trim();
    if (text.isEmpty || profile.value == null) {
      return;
    }
    final entry = JournalEntry(
      id: 'journal_${DateTime.now().millisecondsSinceEpoch}',
      createdAtLabel: _nowLabel(),
      mood: selectedMood.value,
      title: _titleForMood(selectedMood.value),
      body: text,
      sentimentLabel: selectedMood.value.label,
    );
    await _insightRepository.addJournalEntry(profile.value!.id, entry);
    entries.insert(0, entry);
    noteController.clear();
  }

  String _nowLabel() {
    final now = DateTime.now();
    final day = now.day.toString().padLeft(2, '0');
    final month = now.month.toString().padLeft(2, '0');
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    return '$day/$month/${now.year} $hour:$minute';
  }

  String _titleForMood(JournalMood mood) {
    switch (mood) {
      case JournalMood.bright:
        return 'Khí sáng và dễ hành động';
      case JournalMood.deep:
        return 'Cần chậm lại để nhìn rõ';
      case JournalMood.mist:
        return 'Nhiều tín hiệu cần gạn lọc';
    }
  }

  @override
  void onClose() {
    noteController.dispose();
    super.onClose();
  }
}
