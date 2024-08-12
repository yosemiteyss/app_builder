import 'package:app_builder/main.dart';
import 'package:app_builder/module/common/model/package.dart';
import 'package:app_builder/module/tools/bloc/tools_bloc.dart';
import 'package:app_builder/module/tools/bloc/tools_event.dart';
import 'package:app_builder/module/tools/model/tools_state.dart';
import 'package:app_builder/utils/build_context_ext.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ToolsPage extends StatefulWidget {
  const ToolsPage({super.key});

  @override
  State<ToolsPage> createState() => _ToolsPageState();
}

class _ToolsPageState extends State<ToolsPage> {
  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    return BlocProvider(
      create: (context) => ToolsBloc(getIt())..add(OnToolsInit()),
      child: ScaffoldPage.scrollable(
        header: PageHeader(
          title: Text(context.l10n.toolsPageTitle),
        ),
        children: [
          Expander(
            initiallyExpanded: true,
            header: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.uninstallPackages,
                    style: theme.typography.bodyStrong,
                  ),
                  BlocBuilder<ToolsBloc, ToolsState>(
                    builder: (context, state) {
                      return ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: 60),
                        child: FilledButton(
                          onPressed: state.packages.isEmpty &&
                                  state.selectedDeviceId != null
                              ? null
                              : () {
                                  _confirmUninstall(context);
                                },
                          child: Text(context.l10n.startAction),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            content: CustomScrollView(
              shrinkWrap: true,
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: BlocBuilder<ToolsBloc, ToolsState>(
                      builder: (context, state) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 140,
                              child: Text(
                                context.l10n.devices,
                                style: theme.typography.bodyStrong,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(FluentIcons.refresh),
                                  onPressed: () {
                                    context
                                        .read<ToolsBloc>()
                                        .add(OnRefreshDevices());
                                  },
                                ),
                                if (state.deviceIds.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: DropDownButton(
                                      title: Text(
                                        state.selectedDeviceId ??
                                            context.l10n.selectAction,
                                      ),
                                      items: state.deviceIds.map((deviceId) {
                                        return MenuFlyoutItem(
                                          text: Text(deviceId),
                                          onPressed: () {
                                            context
                                                .read<ToolsBloc>()
                                                .add(OnSetDeviceId(deviceId));
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                BlocSelector<ToolsBloc, ToolsState, List<Package>>(
                  selector: (state) => state.packages,
                  builder: (context, state) {
                    return SliverList.separated(
                      itemCount: state.length,
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 8);
                      },
                      itemBuilder: (context, index) {
                        return _PackageRow(package: state[index]);
                      },
                    );
                  },
                ),
                BlocSelector<ToolsBloc, ToolsState, List<Package>>(
                  selector: (state) => state.packages,
                  builder: (context, state) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: state.isNotEmpty ? 8 : 0,
                        ),
                        child: _PackageRow(key: UniqueKey()),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmUninstall(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (dialogContext) {
        return ContentDialog(
          title: Text(context.l10n.confirmUninstall),
          content: Text(context.l10n.confirmUninstallDesc),
          actions: [
            FilledButton(
              child: Text(context.l10n.yes),
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<ToolsBloc>().add(OnUninstallPackages());
              },
            ),
            Button(
              child: Text(context.l10n.no),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
            ),
          ],
        );
      },
    );
  }
}

class _PackageRow extends StatefulWidget {
  const _PackageRow({super.key, this.package});

  final Package? package;

  @override
  State<_PackageRow> createState() => _PackageRowState();
}

class _PackageRowState extends State<_PackageRow> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.package?.name);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextBox(
            controller: _controller,
            enabled: widget.package == null,
            onSubmitted: (value) {
              context
                  .read<ToolsBloc>()
                  .add(OnAddUninstallPackage(_controller.text));
            },
          ),
        ),
        if (widget.package != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: widget.package?.state.build(context),
          ),
        const SizedBox(width: 8),
        IconButton(
          icon: Icon(
            widget.package == null ? FluentIcons.add : FluentIcons.remove,
          ),
          onPressed: () {
            if (widget.package == null) {
              context
                  .read<ToolsBloc>()
                  .add(OnAddUninstallPackage(_controller.text));
            } else {
              if (widget.package != null) {
                context
                    .read<ToolsBloc>()
                    .add(OnRemoveUninstallPackage(widget.package!));
              }
            }
          },
        ),
      ],
    );
  }
}
