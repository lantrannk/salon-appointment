import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/appointments/screens/appointment_form/appointment_form.dart';
import '../constants/constants.dart';
import '../generated/l10n.dart';
import '../theme/theme_provider.dart';
import '../utils/common.dart';
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
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Text(widget.title),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
              right: 12,
            ),
            child: Container(
              width: 36,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: colorScheme.primaryContainer,
                    strokeAlign: BorderSide.strokeAlignInside,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: SAButton.icon(
                onPressed: themeProvider.toggleTheme,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: SAIcons(
                    icon: themeProvider.themeMode == ThemeMode.dark
                        ? Assets.lightIcon
                        : Assets.darkIcon,
                    size: 20,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: widget.child,
      floatingActionButton: SAButton.floating(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AppointmentForm(),
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
              color: colorScheme.shadow,
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
                    Navigator.pushNamed(context, Routes.appointment);
                    break;
                  case 1:
                    // Calendar Screen
                    Navigator.pushNamed(context, Routes.calendar);
                    break;
                  case 3:
                    // Profile Screen
                    Navigator.pushNamed(context, Routes.profile);
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
            topColor: colorScheme.secondaryContainer,
            bottomColor: colorScheme.primaryContainer,
          ),
          activeIcon: _buildIcon(
            icon: Assets.checkIcon,
            topColor: colorScheme.primary,
            bottomColor: colorScheme.secondary,
            isActive: true,
          ),
          label: l10n.appointmentsLabel,
        ),
        BottomNavigationBarItem(
          icon: _buildIcon(
            icon: Assets.scheduleIcon,
            topColor: colorScheme.secondaryContainer,
            bottomColor: colorScheme.primaryContainer,
          ),
          activeIcon: _buildIcon(
            icon: Assets.scheduleIcon,
            topColor: colorScheme.primary,
            bottomColor: colorScheme.secondary,
            isActive: true,
          ),
          label: l10n.calendarLabel,
        ),
        BottomNavigationBarItem(
          icon: context.sizedBox(width: 119),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: _buildIcon(
            icon: Assets.personIcon,
            topColor: colorScheme.secondaryContainer,
            bottomColor: colorScheme.primaryContainer,
          ),
          activeIcon: _buildIcon(
            icon: Assets.personIcon,
            topColor: colorScheme.primary,
            bottomColor: colorScheme.secondary,
            isActive: true,
          ),
          label: l10n.profileLabel,
        ),
        BottomNavigationBarItem(
          icon: _buildIcon(
            icon: Assets.notificationsIcon,
            topColor: colorScheme.secondaryContainer,
            bottomColor: colorScheme.primaryContainer,
          ),
          activeIcon: _buildIcon(
            icon: Assets.notificationsIcon,
            topColor: colorScheme.primary,
            bottomColor: colorScheme.secondary,
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
        !isActive
            ? const SizedBox(height: 2)
            : Center(
                child: Container(
                  height: 2,
                  width: size,
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
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: const [
                0.0,
                0.7,
              ],
              tileMode: TileMode.mirror,
            ),
          ),
        ),
      ],
    ),
  );
}
