import 'package:flutter/material.dart';
import 'package:flutter_web_android/components/custom_loading.dart';
import 'package:flutter_web_android/components/table_flexible.dart';
import 'package:flutter_web_android/screens/cargos/cargos_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_android/components/edit_cargo_modal.dart';
import 'package:flutter_web_android/components/create_cargo_modal.dart';

class CargosScreen extends StatelessWidget {
  const CargosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CargosViewModel(),
      child: const _CargosScreenContent(),
    );
  }
}

class _CargosScreenContent extends StatelessWidget {
  const _CargosScreenContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Gestión de Cargos',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A8A),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showCreateCargoModal(context),
                icon: const Icon(Icons.add),
                label: const Text('Nuevo Cargo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (context.select((CargosViewModel vm) => vm.errorMessage) != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Text(
                context.read<CargosViewModel>().errorMessage!,
                style: TextStyle(color: Colors.red.shade700),
              ),
            ),
          Expanded(
            child: Consumer<CargosViewModel>(
              builder: (context, viewModel, _) {
                if (viewModel.isLoading) {
                  return const Center(child: CustomLoading());
                }

                return CustomDataTable(
                  columns: const [
  ColumnConfig(
    label: 'Cargo',
    field: 'cargo_nombre',
    width: 200,
  ),
  ColumnConfig(
    label: 'Abreviatura',
    field: 'abreviatura',
    width: 150,
  ),
  ColumnConfig(
    label: 'Usuario',
    field: 'nombre_usuario',
    width: 200,
  ),
  ColumnConfig(
    label: 'Organización',
    field: 'nombre_organizacion',
    width: 200,
  ),
],
data: viewModel.cargos.map((cargo) => {
  'id': cargo.id,
  'cargo_nombre': cargo.cargoNombre, // Nuevo campo
  'abreviatura': cargo.abreviatura,
  'nombre_usuario': cargo.nombreUsuario,
  'nombre_organizacion': cargo.nombreOrganizacion,
  'id_organizacion': cargo.idOrganizacion,
  'id_usuario': cargo.idUsuario,
}).toList(),
                  actions: [
                    TableAction(
                      icon: Icons.edit,
                      color: const Color(0xFF1E3A8A),
                      tooltip: 'Editar',
                      onPressed: (row) => _showEditCargoModal(context, row),
                    ),
                    TableAction(
                      icon: Icons.delete,
                      color: Colors.red,
                      tooltip: 'Eliminar',
                      onPressed: (row) => _showDeleteConfirmation(context, row),
                    ),
                  ],
                  title: 'Cargos',
                  primaryColor: const Color(0xFF1E3A8A),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateCargoModal(BuildContext context) async {
  final viewModel = context.read<CargosViewModel>();
  final result = await showCreateCargoModal(context, viewModel.usuarios);
  if (result != null && context.mounted) {
    final idOrganizacion = viewModel.cargos.isNotEmpty 
        ? viewModel.cargos.first.idOrganizacion 
        : 1;

    await viewModel.createCargo(
  idOrganizacion: idOrganizacion,
  idUsuario: result['id_usuario'],
  abreviatura: result['abreviatura'],
  cargoNombre: result['cargo_nombre'],
);
  }
}

void _showEditCargoModal(BuildContext context, Map<String, dynamic> cargo) async {
  final viewModel = context.read<CargosViewModel>();
  final result = await showEditCargoModal(context, cargo, viewModel.usuarios);
  if (result != null && context.mounted) {
    await viewModel.updateCargo(
  cargoId: cargo['id'],
  idUsuario: result['id_usuario'],
  abreviatura: result['abreviatura'],
  cargoNombre: result['cargo_nombre'],
);
  }
}

  void _showDeleteConfirmation(BuildContext context, Map<String, dynamic> row) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Confirmar eliminación'),
      content: Text('¿Está seguro de eliminar el cargo "${row['abreviatura']}"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Text('Eliminar'),
        ),
      ],
    ),
  );

  // Solo proceder si el usuario confirmó
  if (result == true && context.mounted) {
    final viewModel = context.read<CargosViewModel>();
    try {
      final success = await viewModel.deleteCargo(row['id']);

      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cargo eliminado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(viewModel.errorMessage ?? 'Error al eliminar cargo'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
}