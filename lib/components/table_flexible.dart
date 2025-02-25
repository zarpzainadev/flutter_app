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
    this.onPressed,
    this.getColor,
    this.getTooltip,
  });
}

class CustomDataTable extends StatefulWidget {
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
    this.title = 'Tabla',
    this.onCreateNew,
    this.onSearch,
    this.primaryColor = const Color(0xFF1E3A8A),
    this.headerActions = const [],
  }) : super(key: key);

  @override
  State<CustomDataTable> createState() => _CustomDataTableState();
}

class _CustomDataTableState extends State<CustomDataTable> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();
  final Map<String, DataRow> _rowCache = {};

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    _rowCache.clear();
    super.dispose();
  }

  DataRow _buildDataRow(Map<String, dynamic> row, double defaultColumnWidth) {
    // Usar el toString() del row como key para el cache
    final key = row.toString();
    if (_rowCache.containsKey(key)) {
      return _rowCache[key]!;
    }

    final dataRow = DataRow(
      cells: [
        ...widget.columns.map((col) => DataCell(
          RepaintBoundary(
            child: SizedBox(
              width: col.width ?? defaultColumnWidth,
              child: Tooltip(
                message: row[col.field]?.toString() ?? '',
                child: Text(
                  row[col.field]?.toString() ?? '',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        )),
        if (widget.actions.isNotEmpty)
          DataCell(
            RepaintBoundary(
              child: SizedBox(
                width: widget.actions.length * 48.0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.actions.map((action) {
                    return IconButton(
                      icon: Icon(action.icon),
                      color: action.getColor?.call(row) ?? action.color,
                      tooltip: action.getTooltip?.call(row) ?? action.tooltip,
                      onPressed: () => action.onPressed?.call(row),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
      ],
    );

    _rowCache[key] = dataRow;
    return dataRow;
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
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
            RepaintBoundary(child: _buildHeader(context)),
            const SizedBox(height: 24),
            Expanded(
              child: _buildTableContent(context),
            ),
            RepaintBoundary(child: _buildFooter(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildTableContent(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final defaultColumnWidth = (availableWidth - (widget.actions.isEmpty ? 0 : 120)) / widget.columns.length;

        return Scrollbar(
          controller: _verticalController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _verticalController,
            child: Scrollbar(
              controller: _horizontalController,
              thumbVisibility: true,
              scrollbarOrientation: ScrollbarOrientation.bottom,
              child: SingleChildScrollView(
                controller: _horizontalController,
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: availableWidth,
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dataTableTheme: DataTableThemeData(
                        headingTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: widget.primaryColor,
                        ),
                      ),
                    ),
                    child: DataTable(
                      columnSpacing: 24,
                      horizontalMargin: 24,
                      columns: [
                        ...widget.columns.map((col) => DataColumn(
                          label: RepaintBoundary(
                            child: SizedBox(
                              width: col.width ?? defaultColumnWidth,
                              child: Text(col.label),
                            ),
                          ),
                        )),
                        if (widget.actions.isNotEmpty)
                          const DataColumn(
                            label: Text('Acciones'),
                          ),
                      ],
                      rows: List.generate(
                        widget.data.length,
                        (index) => _buildDataRow(widget.data[index], defaultColumnWidth),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            if (widget.onSearch != null)
              SizedBox(
                width: 200,
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Buscar...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: widget.onSearch,
                ),
              ),
            ...widget.headerActions,
          ],
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Text(
        '${widget.data.length} registros',
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}