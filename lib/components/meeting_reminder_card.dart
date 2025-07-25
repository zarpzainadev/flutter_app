// lib/components/meeting_reminder_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class MeetingReminderCard extends StatelessWidget {
  final String date;
  final String place;
  final Map<String, dynamic> agenda;

  const MeetingReminderCard({
    Key? key,
    required this.date,
    required this.place,
    required this.agenda,
  }) : super(key: key);

  const factory MeetingReminderCard.loading() = _LoadingMeetingCard;
  const factory MeetingReminderCard.empty() = _EmptyMeetingCard;
  factory MeetingReminderCard.error(String message) = _ErrorMeetingCard;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWeb = MediaQuery.of(context).size.width > 600;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(isWeb ? 24.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 24),
            _buildInfoSection(theme),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(thickness: 1),
            ),
            _buildAgendaSection(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        const Icon(Icons.event_note, color: Colors.blue, size: 28),
        const SizedBox(width: 12),
        Text(
          'Próxima Reunión',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.blue[700],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
          icon: Icons.calendar_today,
          label: 'Fecha:',
          value: date,
          theme: theme,
        ),
        const SizedBox(height: 12),
        _buildInfoRow(
          icon: Icons.location_on,
          label: 'Lugar:',
          value: place,
          theme: theme,
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required ThemeData theme,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          label,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }

  Widget _buildAgendaSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Agenda',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          padding: const EdgeInsets.all(16),
          child: QuillEditor(
            configurations: QuillEditorConfigurations(
              controller: QuillController(
                document: Document.fromJson(agenda['ops']),
                selection: const TextSelection.collapsed(offset: 0),
                readOnly: true,
              ),
              padding: EdgeInsets.zero,
              autoFocus: false,
              scrollable: true,
              expands: false,
            ),
            focusNode: FocusNode(),
            scrollController: ScrollController(),
          ),
        ),
      ],
    );
  }
}

class _LoadingMeetingCard extends MeetingReminderCard {
  const _LoadingMeetingCard() 
    : super(
        date: 'Cargando...', 
        place: 'Cargando...', 
        agenda: const {'ops': [
          {
            'insert': 'Cargando agenda...\n',
            'attributes': {
              'italic': true,
              'color': '#666666'
            }
          }
        ]}
      );

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 32,
                width: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Cargando próxima reunión...',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyMeetingCard extends MeetingReminderCard {
  const _EmptyMeetingCard() 
    : super(
        date: 'Sin fecha programada', 
        place: 'Sin lugar asignado', 
        agenda: const {'ops': [
          {
            'insert': 'No hay reuniones programadas actualmente.\nTe notificaremos cuando haya una nueva reunión.\n',
            'attributes': {
              'italic': true,
              'color': '#666666'
            }
          }
        ]}
      );

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.event_busy, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No hay reuniones programadas',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Te notificaremos cuando haya una nueva reunión',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorMeetingCard extends MeetingReminderCard {
  final String message;

  _ErrorMeetingCard(this.message)
      : super(
          date: 'Error', 
          place: 'Error', 
          agenda: {'ops': [
            {
              'insert': 'Error al cargar la reunión.\n',
              'attributes': {'color': '#FF0000'}
            }
          ]}
        );

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              'Error',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.red[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.red[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}