import 'package:flutter/material.dart';

import '../../features/appointments/screens/new_appointment_screen.dart';
import '../constants/assets.dart';
import '../generated/l10n.dart';
import '../utils.dart';
import '../widgets/widgets.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({
    required this.title,
    required this.currentIndex,
    required this.child,
    required this.selectedDay,
    super.key,
  });

  final String title;
  final Widget child;
  final int currentIndex;
  final DateTime selectedDay;

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final FloatingActionButtonLocation _fabLocation =
      FloatingActionButtonLocation.centerDocked;

  late int _currentIndex;

  @override
  void initState() {
    _currentIndex = widget.currentIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: SAText.appBarTitle(
            text: widget.title,
            style: textTheme.titleLarge!,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: widget.child,
      floatingActionButton: SAButton.floating(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewAppointmentScreen(
                selectedDay: isBeforeNow(widget.selectedDay)
                    ? DateTime.now()
                    : widget.selectedDay,
              ),
            ),
          );
        },
        child: SAIcons(
          icon: Assets.addIcon,
          size: 30,
          color: colorScheme.onPrimary,
        ),
      ),
      floatingActionButtonLocation: _fabLocation,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withOpacity(0.1601),
              offset: const Offset(0, 2),
              blurRadius: 8,
              spreadRadius: 0,
              blurStyle: BlurStyle.outer,
            ),
          ],
        ),
        child: CustomBottomAppBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (_currentIndex == index) {
              return;
            } else {
              setState(() {
                _currentIndex = index;
                switch (_currentIndex) {
                  case 0:
                    // Appointment Screen
                    Navigator.pushNamed(context, '/appointment');
                    break;
                  case 1:
                    // Calendar Screen
                    Navigator.pushNamed(context, '/calendar');
                    break;
                  case 3:
                    // Profile Screen
                    Navigator.pushNamed(context, '/profile');
                    break;
                }
              });
            }
          },
        ),
      ),
    );
  }
}

class CustomBottomAppBar extends StatelessWidget {
  const CustomBottomAppBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final int currentIndex;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final l10n = S.of(context);

    return BottomNavigationBar(
      backgroundColor: colorScheme.onPrimary,
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedFontSize: 0,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: _buildIcon(
            icon: Assets.checkIcon,
            topColor: colorScheme.onTertiary,
            bottomColor: colorScheme.onSecondary,
          ),
          activeIcon: _buildIcon(
            icon: Assets.checkIcon,
            topColor: colorScheme.primary,
            bottomColor: colorScheme.onSurface,
            isActive: true,
          ),
          label: l10n.appointmentsLabel,
        ),
        BottomNavigationBarItem(
          icon: _buildIcon(
            icon: Assets.scheduleIcon,
            topColor: colorScheme.onTertiary,
            bottomColor: colorScheme.onSecondary,
          ),
          activeIcon: _buildIcon(
            icon: Assets.scheduleIcon,
            topColor: colorScheme.primary,
            bottomColor: colorScheme.onSurface,
            isActive: true,
          ),
          label: l10n.calendarLabel,
        ),
        const BottomNavigationBarItem(
          icon: SizedBox(
            width: 119,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: _buildIcon(
            icon: Assets.personIcon,
            topColor: colorScheme.onTertiary,
            bottomColor: colorScheme.onSecondary,
          ),
          activeIcon: _buildIcon(
            icon: Assets.personIcon,
            topColor: colorScheme.primary,
            bottomColor: colorScheme.onSurface,
            isActive: true,
          ),
          label: l10n.profileLabel,
        ),
        BottomNavigationBarItem(
          icon: _buildIcon(
            icon: Assets.notificationsIcon,
            topColor: colorScheme.onTertiary,
            bottomColor: colorScheme.onSecondary,
          ),
          activeIcon: _buildIcon(
            icon: Assets.notificationsIcon,
            topColor: colorScheme.primary,
            bottomColor: colorScheme.onSurface,
            isActive: true,
          ),
          label: l10n.notificationsLabel,
        ),
      ],
    );
  }
}

Widget _buildIcon({
  required IconData icon,
  required Color topColor,
  required Color bottomColor,
  double size = 24,
  double bottomNavigationBarHeight = 80,
  bool isActive = false,
}) {
  return Container(
    width: double.infinity,
    height: bottomNavigationBarHeight,
    margin: EdgeInsets.zero,
    padding: EdgeInsets.zero,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (!isActive)
          const SizedBox(
            height: 2,
          )
        else
          SizedBox(
            height: 2,
            child: Divider(
              thickness: 2,
              indent: 29,
              endIndent: 29,
              color: topColor,
            ),
          ),
        SizedBox(
          height: bottomNavigationBarHeight - 4,
          child: GradientIcon(
            icon: icon,
            size: size,
            gradient: LinearGradient(
              colors: [
                topColor,
                bottomColor,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    ),
  );
}
