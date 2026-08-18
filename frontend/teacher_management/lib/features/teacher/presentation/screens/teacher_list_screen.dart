// features/teachers/presentation/screens/teacher_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teacher_management/core/widgets/default_avatar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../providers/teacher_providers.dart';
import '../widgets/teacher_card.dart';
import '../widgets/group_filter_chip.dart';
import 'package:flutter/rendering.dart';

const _kGroupFilters = ['Tous', 'GB', 'ASR', 'IG', 'OCC', 'GID'];

class TeacherListScreen extends ConsumerStatefulWidget {
  const TeacherListScreen({super.key});

  @override
  ConsumerState<TeacherListScreen> createState() => _TeacherListScreenState();
}

class _TeacherListScreenState extends ConsumerState<TeacherListScreen> {
  String _selectedGroup = 'Tous';
  final _searchController = TextEditingController();

  final _scrollController = ScrollController();

  bool _showSearchAndFilters = true;

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      // L'utilisateur monte dans la liste → afficher
      if (!_showSearchAndFilters) {
        setState(() {
          _showSearchAndFilters = true;
        });
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      // L'utilisateur descend dans la liste → cacher
      if (_showSearchAndFilters) {
        setState(() {
          _showSearchAndFilters = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final teachersAsync = ref.watch(teacherListProvider);

    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            const Divider(height: 1, color: AppColors.line),
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: _showSearchAndFilters
                  ? Container(
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
                      child: Column(
                        children: [
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: 1,
                            child: _buildSearchBar(),
                          ),
                          const SizedBox(height: 14),
                          _buildFilterRow(),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            Expanded(
              child: teachersAsync.when(
                data: (teachers) {
                  final filtered =
                      teachers; // TODO: filtrer par _selectedGroup côté client ou API
                  if (filtered.isEmpty) {
                    return const Center(child: Text('Aucun enseignant trouvé'));
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(top: 6, bottom: 90),
                    itemCount: filtered.length,
                    itemBuilder: (context, i) {
                      final t = filtered[i];

                      return TeacherCard(
                        teacher: t,
                        subtitle: t.grade != null && t.specialty != null
                            ? '${t.grade} - ${t.specialty}'
                            : (t.specialty ?? 'Enseignant'),
                        onTap: () {
                          context.push('/teachers/${t.id}');
                        },
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.eniGreen),
                ),
                error: (e, _) => Center(child: Text('Erreur : $e')),
              ),
            ),
          ],
        ),
      ),
      // teacher_list_screen.dart — remplacer le TODO du FloatingActionButton
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.eniGreen,
        onPressed: () async {
          final added = await context.push<bool>('/teachers/add');
          if (added == true) {
            ref.invalidate(teacherListProvider);
          }
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 1,
        onTap: (i) {
          // TODO: navigation selon l'onglet
        },
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(Icons.menu, color: AppColors.eniGreen, size: 32),
            ),
            const SizedBox(width: 4),
            const Expanded(
              child: Text(
                'Enseignants',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.eniGreen,
                ),
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: DefaultAvatar(size: 24, isAppBar: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          ref.read(searchQueryProvider.notifier).state = value;
        },
        style: const TextStyle(fontSize: 15, color: AppColors.ink),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'Recherche ....',
          hintStyle: const TextStyle(color: AppColors.iconGrey),
          prefixIcon: const Icon(Icons.search, color: AppColors.iconGrey),
          suffixIcon: const Icon(Icons.tune, color: AppColors.eniGreen),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 8,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterRow() {
    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _kGroupFilters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final label = _kGroupFilters[i];
          return GroupFilterChip(
            label: label,
            selected: _selectedGroup == label,
            onTap: () => setState(() => _selectedGroup = label),
          );
        },
      ),
    );
  }
}
