import 'package:flutter/material.dart';
import '../../../../core/responsive/responsive_layout.dart';
import 'admin_header.dart';
import 'admin_sidebar.dart';

class AdminScaffold extends StatefulWidget {
  final String title;
  final String currentRoute;
  final Widget child;
  final List<Widget>? actions;

  const AdminScaffold({
    super.key,
    required this.title,
    required this.currentRoute,
    required this.child,
    this.actions,
  });

  @override
  State<AdminScaffold> createState() => _AdminScaffoldState();
}

class _AdminScaffoldState extends State<AdminScaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = Responsive.isDesktop(context) || Responsive.isWideDesktop(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: !isDesktop
          ? Drawer(
              child: AdminSidebar(
                currentRoute: widget.currentRoute,
                isCollapsed: false,
              ),
            )
          : null,
      body: Row(
        children: [
          if (isDesktop)
            AdminSidebar(
              currentRoute: widget.currentRoute,
              isCollapsed: _isCollapsed,
              onToggleCollapse: () => setState(() => _isCollapsed = !_isCollapsed),
            ),
          Expanded(
            child: Column(
              children: [
                AdminHeader(
                  title: widget.title,
                  actions: widget.actions,
                  onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: widget.child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
