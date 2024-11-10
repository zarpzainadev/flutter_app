import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_android/components/OptionBlocks.dart';

class Sidebar extends StatefulWidget {
  final Function(Widget) onSelectScreen;

  const Sidebar({
    Key? key,
    required this.onSelectScreen,
  }) : super(key: key);

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  bool _isExpanded = true;
  String _selectedRole = 'tesorero'; // Por defecto mostramos opciones de admin

  @override
  Widget build(BuildContext context) {
    // Versión Android (sin modificar)
    if (!kIsWeb) {
      return Drawer(
        child: Container(
          color: Theme.of(context).primaryColor, // Cambiar el fondo a morado
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: const Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              if (_selectedRole == 'tesorero') ...[
                TesoreroOptions(
                  onSelectScreen: widget.onSelectScreen,
                  isExpanded: true,
                ),
              ],
              if (_selectedRole == 'secretario') ...[
                SecretarioOptions(
                  onSelectScreen: widget.onSelectScreen,
                  isExpanded: true,
                ),
              ],
              if (_selectedRole == 'admin') ...[
                AdminOptions(
                  onSelectScreen: widget.onSelectScreen,
                  isExpanded: true,
                ),
                UserManagementOptions(
                  onSelectScreen: widget.onSelectScreen,
                  isExpanded: true,
                ),
              ],
            ],
          ),
        ),
      );
    }

    // Versión web con sidebar colapsable
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: _isExpanded ? 240 : 72,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo section
          Container(
            height: 60,
            alignment: Alignment.center,
            child: _isExpanded
                ? const Text(
                    'Company Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : const Icon(
                    Icons.business,
                    color: Colors.white,
                    size: 32,
                  ),
          ),
          const Divider(color: Colors.white24, height: 1),

          // Role selector
          if (_isExpanded) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                isExpanded: true,
                dropdownColor: Theme.of(context).primaryColor,
                value: _selectedRole,
                style: const TextStyle(color: Colors.white),
                underline: Container(
                  height: 2,
                  color: Colors.white24,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRole = newValue!;
                  });
                },
                items: <String>['admin', 'tesorero', 'secretario']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value.toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],

          // Menu items based on role
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (_selectedRole == 'tesorero') ...[
                    TesoreroOptions(
                      onSelectScreen: widget.onSelectScreen,
                      isExpanded: _isExpanded,
                    ),
                  ],
                  if (_selectedRole == 'secretario') ...[
                    SecretarioOptions(
                      onSelectScreen: widget.onSelectScreen,
                      isExpanded: _isExpanded,
                    ),
                  ],
                  if (_selectedRole == 'admin') ...[
                    AdminOptions(
                      onSelectScreen: widget.onSelectScreen,
                      isExpanded: _isExpanded,
                    ),
                    const Divider(color: Colors.white24, height: 1),
                    UserManagementOptions(
                      onSelectScreen: widget.onSelectScreen,
                      isExpanded: _isExpanded,
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Expand/collapse button at bottom
          const Divider(color: Colors.white24, height: 1),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Container(
                height: 56,
                padding: EdgeInsets.symmetric(
                  horizontal: _isExpanded ? 16 : 0,
                ),
                child: Row(
                  mainAxisAlignment: _isExpanded
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isExpanded ? Icons.chevron_left : Icons.chevron_right,
                      color: Colors.white,
                      size: 24,
                    ),
                    if (_isExpanded) ...[
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          _isExpanded ? 'Collapse' : 'Expand',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// Aquí van las clases de opciones que te proporcioné anteriormente:
// TesoreroOptions, SecretarioOptions, AdminOptions, UserManagementOptions
// y la función buildSidebarItem