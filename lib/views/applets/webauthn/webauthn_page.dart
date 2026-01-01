import 'package:canokey_console/controller/applets/webauthn/webauthn_controller.dart';
import 'package:canokey_console/generated/l10n.dart';
import 'package:canokey_console/helper/theme/admin_theme.dart';
import 'package:canokey_console/helper/utils/ui_mixins.dart';
import 'package:canokey_console/helper/widgets/customized_text.dart';
import 'package:canokey_console/helper/widgets/no_credential_screen.dart';
import 'package:canokey_console/helper/widgets/poll_canokey_screen.dart';
import 'package:canokey_console/helper/widgets/responsive.dart';
import 'package:canokey_console/helper/widgets/search_box.dart';
import 'package:canokey_console/helper/widgets/spacing.dart';
import 'package:canokey_console/models/webauthn.dart';
import 'package:canokey_console/views/applets/webauthn/widgets/top_actions.dart';
import 'package:canokey_console/views/applets/webauthn/widgets/webauthn_item_card.dart';
import 'package:canokey_console/views/layout/layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class WebAuthnPage extends StatefulWidget {
  const WebAuthnPage({super.key});

  @override
  State<WebAuthnPage> createState() => _WebAuthnPageState();
}

class _WebAuthnPageState extends State<WebAuthnPage> with SingleTickerProviderStateMixin, UIMixin {
  final WebAuthnController controller = Get.put(WebAuthnController());
  final RxString searchText = ''.obs;
  final RxBool sortAlphabetically = false.obs;
  final GlobalKey<FormState> _searchFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Get.put(searchText, tag: 'webauthn_search');
    Get.put(sortAlphabetically, tag: 'webauthn_sort');
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: 'WebAuthn',
      topActions: Row(
        children: [
          Obx(() => InkWell(
            onTap: () => sortAlphabetically.value = !sortAlphabetically.value,
            child: Icon(
              sortAlphabetically.value ? LucideIcons.arrowDownAZ : LucideIcons.clock,
              size: 20,
              color: topBarTheme.onBackground,
            ),
          )),
          Spacing.width(12),
          TopActions(controller: controller),
        ],
      ),
      child: GetBuilder(
        init: controller,
        builder: (_) {
          if (!controller.polled) {
            return PollCanoKeyScreen();
          }
          if (controller.webAuthnItems.isEmpty) {
            return NoCredentialScreen();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: Spacing.x(flexSpacing),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (ScreenMedia.getTypeFromWidth(MediaQuery.of(context).size.width).isMobile) ...{
                      Spacing.height(16),
                      SearchBox(formKey: _searchFormKey),
                    },
                    Spacing.height(16),
                    Obx(() {
                      final filteredItems = searchText.value.isEmpty
                          ? controller.webAuthnItems
                          : controller.webAuthnItems
                              .where((item) =>
                                  item.rpId.toLowerCase().contains(searchText.value.toLowerCase()) ||
                                  item.userDisplayName.toLowerCase().contains(searchText.value.toLowerCase()))
                              .toList();
                      if (filteredItems.isEmpty) return Center(child: CustomizedText.bodyMedium(S.of(context).noMatchingCredential, fontSize: 24));
                      final items = List<WebAuthnItem>.from(filteredItems);
                      if (sortAlphabetically.value) {
                        items.sort((a, b) {
                          final aName = a.userDisplayName.isEmpty ? a.rpId : a.userDisplayName;
                          final bName = b.userDisplayName.isEmpty ? b.rpId : b.userDisplayName;
                          return aName.toLowerCase().compareTo(bName.toLowerCase());
                        });
                      }
                      return GridView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: items.length,
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 500,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          mainAxisExtent: 120,
                        ),
                        itemBuilder: (context, index) => WebAuthnItemCard(
                          item: items[index],
                          controller: controller,
                        ),
                      );
                    })
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
