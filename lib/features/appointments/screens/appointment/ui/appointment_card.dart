import 'package:flutter/material.dart';

import '../../../../../core/constants/constants.dart';
import '../../../../../core/generated/l10n.dart';
import '../../../../../core/utils/common.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../model/appointment.dart';
import 'appointment_card/appointment_card.dart';

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({
    required this.appointment,
    required this.name,
    required this.avatar,
    required this.onEditPressed,
    required this.onRemovePressed,
    super.key,
  });

  final Appointment appointment;
  final String name;
  final String avatar;
  final VoidCallback onEditPressed;
  final VoidCallback onRemovePressed;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.only(
        left: 24,
        right: 24,
        top: 12,
      ),
      margin: const EdgeInsets.only(
        left: 8,
        right: 8,
        top: 8,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow,
            offset: const Offset(0, 0),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Time(
                startTime: appointment.startTime,
                endTime: appointment.endTime,
                text: S.of(context).beautySalonText,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SAButton.icon(
                    onPressed: onEditPressed,
                    child: SAIcons(
                      icon: Assets.editIcon,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  context.sizedBox(width: 8),
                  SAButton.icon(
                    onPressed: onRemovePressed,
                    child: SAIcons(
                      icon: Assets.removeIcon,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              )
            ],
          ),
          context.sizedBox(height: 12),
          Customer(
            name: name,
            avatar: avatar,
          ),
          context.sizedBox(height: 12),
          Service(
            service: appointment.services,
          ),
          context.sizedBox(height: 12),
          Description(
            description: appointment.description,
          ),
          context.sizedBox(height: 12),
        ],
      ),
    );
  }
}
