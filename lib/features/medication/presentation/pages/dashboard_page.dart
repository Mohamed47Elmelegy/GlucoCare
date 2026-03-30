import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_test_ai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_test_ai/l10n/app_localizations.dart';
import '../../../../core/routes/route_constants.dart';
import '../bloc/medication_bloc.dart';
import '../bloc/medication_event.dart';
import '../bloc/medication_state.dart';
import '../../domain/entities/medication.dart';
import '../../domain/entities/dose_history.dart';
import '../../domain/entities/dose_status.dart';
import 'package:uuid/uuid.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/premium_card.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/extensions/context_extension.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<MedicationBloc>().add(LoadTodaySchedule(DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: BlocConsumer<MedicationBloc, MedicationState>(
        listener: (context, state) {
          if (state is MedicationActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: colorScheme.primary,
                behavior: SnackBarBehavior.floating,
              ),
            );
            context.read<MedicationBloc>().add(
              LoadTodaySchedule(DateTime.now()),
            );
          } else if (state is MedicationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: colorScheme.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is MedicationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TodayScheduleLoaded) {
            return _DashboardContent(
              medications: state.activeMedications,
              history: state.takenHistory,
            );
          }

          if (state is MedicationLoaded) {
            return _DashboardContent(
              medications: state.medications,
              history: const [],
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  PhosphorIcons.warningCircle(PhosphorIconsStyle.fill),
                  size: 48,
                  color: colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(l10n.errorOccurred),
                TextButton(
                  onPressed: () => context.read<MedicationBloc>().add(
                    LoadTodaySchedule(DateTime.now()),
                  ),
                  child: Text(l10n.retry),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final List<Medication> medications;
  final List<DoseHistory> history;

  const _DashboardContent({required this.medications, required this.history});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final l10n = AppLocalizations.of(context)!;

    final progress = medications.isEmpty
        ? 0.0
        : history.length / medications.length;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          expandedHeight: 280,
          pinned: true,
          stretch: true,
          backgroundColor: colorScheme.primary,
          elevation: 0,
          leading: const SizedBox.shrink(),
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: const [
              StretchMode.zoomBackground,
              StretchMode.blurBackground,
            ],
            background: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colorScheme.primary,
                        colorScheme.primary.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: -50,
                  right: -50,
                  child: CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, authState) {
                                String name = l10n.userName;
                                if (authState is AuthSuccess) {
                                  name = authState.user.name;
                                }
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${l10n.goodMorning},',
                                      style: textTheme.bodyLarge?.copyWith(
                                        color: Colors.white.withValues(
                                          alpha: 0.8,
                                        ),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      name,
                                      style: textTheme.headlineSmall?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  width: 2,
                                ),
                              ),
                              child: const CircleAvatar(
                                radius: 24,
                                backgroundImage: NetworkImage(
                                  'https://i.pravatar.cc/150?u=a042581f4e29026704d',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.2),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        l10n.dailyProgress,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        '${(progress * 100).toInt()}%',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: LinearProgressIndicator(
                                      value: progress,
                                      minHeight: 8,
                                      backgroundColor: Colors.white.withValues(
                                        alpha: 0.2,
                                      ),
                                      valueColor: const AlwaysStoppedAnimation(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    '${history.length} of ${medications.length} ${l10n.todaysDoses}',
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.todaysDoses,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                TextButton(onPressed: () {}, child: Text(l10n.viewAll)),
              ],
            ),
          ),
        ),
        if (medications.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PremiumCard(
                    glassmorphic: true,
                    child: Icon(
                      PhosphorIcons.pill(PhosphorIconsStyle.light),
                      size: 80,
                      color: colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.noMedicationsScheduled,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final med = medications[index];
                final isTakenToday = history.any(
                  (h) => h.medicationId == med.id,
                );
                final isInjection = med.type.name.toLowerCase().contains(
                  'injection',
                );

                return PremiumCard(
                  padding: EdgeInsets.zero,
                  margin: const EdgeInsets.only(bottom: 16),
                  glassmorphic: false,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: isTakenToday
                            ? Colors.green.withValues(alpha: 0.1)
                            : colorScheme.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Icon(
                          isInjection
                              ? PhosphorIcons.syringe(PhosphorIconsStyle.fill)
                              : PhosphorIcons.pill(PhosphorIconsStyle.fill),
                          color: isTakenToday
                              ? Colors.green
                              : AppColors.premiumMint,
                          size: 28,
                        ),
                      ),
                    ),
                    title: Text(
                      med.name,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isTakenToday
                            ? Colors.green.shade800
                            : colorScheme.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      '${med.dosage} ${med.unit} • ${med.mealSlots.map((slot) => '${slot.label} (${med.customTimes[slot]?.format(context) ?? ""})').join(", ")}',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: isTakenToday
                        ? Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              PhosphorIcons.check(PhosphorIconsStyle.bold),
                              color: Colors.green,
                              size: 20,
                            ),
                          )
                        : SizedBox(
                            width: 80,
                            height: 40,
                            child: AppButton(
                              text: l10n.take,
                              fontSize: 14,
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                final hist = DoseHistory(
                                  id: const Uuid().v4(),
                                  medicationId: med.id,
                                  dateTime: DateTime.now(),
                                  status: DoseStatus.taken,
                                  notes: '',
                                );
                                context.read<MedicationBloc>().add(
                                  MarkMedicationAsTaken(hist),
                                );
                              },
                            ),
                          ),
                    onTap: () {
                      context.push(RouteConstants.editMedication, extra: med);
                    },
                  ),
                );
              }, childCount: medications.length),
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}
