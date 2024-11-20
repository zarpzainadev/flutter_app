import 'package:flutter/material.dart';
import 'dart:math';

class ColumnConfig {
  final String label;
  final String field;
  final double? width;

  const ColumnConfig({
    required this.label,
    required this.field,
    this.width,
  });
}

class TableAction {
  final IconData icon;
  final Color color;
  final String tooltip;
  final Function(Map<String, dynamic>)? onPressed;
  final Color Function(Map<String, dynamic>)? getColor;
  final String Function(Map<String, dynamic>)? getTooltip;

  const TableAction({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onPressed,
    this.getColor,
    this.getTooltip,
  });
}

class CustomDataTable extends StatelessWidget {
  final List<ColumnConfig> columns;
  final List<Map<String, dynamic>> data;
  final List<TableAction> actions;
  final String title;
  final VoidCallback? onCreateNew;
  final Function(String)? onSearch;
  final Color primaryColor;
  final List<Widget> headerActions;

  const CustomDataTable({
    Key? key,
    required this.columns,
    required this.data,
    required this.actions,
    this.title = 'Productos',
    this.onCreateNew,
    this.onSearch,
    this.primaryColor = const Color(0xFF1E3A8A),
    this.headerActions = const [],
  }) : super(key: key);

  bool _isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          _buildTable(context),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isMobile = _isMobile(context);

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isMobile ? 20 : 24,
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...headerActions,
            if (onCreateNew != null)
              ElevatedButton(
                onPressed: onCreateNew,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 12 : 20,
                    vertical: isMobile ? 8 : 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'CREAR NUEVO',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: isMobile ? 12 : 14,
                  ),
                ),
              ),
            if (onSearch != null)
              Container(
                width: isMobile ? 150 : 200,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  onChanged: onSearch,
                  decoration: const InputDecoration(
                    hintText: 'Buscar...',
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildTable(BuildContext context) {
    final isMobile = _isMobile(context);
    final tableContent = DataTable(
      columnSpacing: isMobile ? 8 : 16,
      horizontalMargin: isMobile ? 8 : 16,
      headingRowHeight: isMobile ? 40 : 56,
      dataRowHeight: isMobile ? 48 : 52,
      columns: [
        ...columns.map(
          (col) => DataColumn(
            label: Expanded(
              child: Text(
                col.label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isMobile ? 12 : 14,
                ),
              ),
            ),
          ),
        ),
        if (actions.isNotEmpty) const DataColumn(label: Text('Acciones')),
      ],
      rows: data.map((row) {
        return DataRow(
          cells: [
            ...columns.map(
              (col) => DataCell(
                Container(
                  constraints: BoxConstraints(
                    maxWidth: col.width ?? (isMobile ? 120 : 200),
                  ),
                  child: Text(
                    row[col.field]?.toString() ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: isMobile ? 12 : 14,
                    ),
                  ),
                ),
              ),
            ),
            if (actions.isNotEmpty)
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: actions.map((action) {
                    return IconButton(
                      icon: Icon(action.icon, size: isMobile ? 20 : 24),
                      color: action.getColor?.call(row) ?? action.color,
                      tooltip: action.getTooltip?.call(row) ?? action.tooltip,
                      onPressed: action.onPressed == null
                          ? null
                          : () => action.onPressed!(row),
                    );
                  }).toList(),
                ),
              ),
          ],
        );
      }).toList(),
    );

    return isMobile
        ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: tableContent,
          )
        : tableContent;
  }

  Widget _buildFooter(BuildContext context) {
    final isMobile = _isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 8 : 16,
        horizontal: isMobile ? 8 : 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '${data.length} registros',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: isMobile ? 12 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
