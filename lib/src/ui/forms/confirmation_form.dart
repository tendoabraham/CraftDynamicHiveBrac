import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';

class ConfirmationForm {
  static confirmTransaction(context, List<FormItem> formItems,
      ModuleItem moduleItem, Map<String?, dynamic> input) {
    final formKey = GlobalKey<FormState>();

    return showModalBottomSheet<void>(
      showDragHandle: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 4),
            decoration: const BoxDecoration(
                image: DecorationImage(
              opacity: .1,
              image: AssetImage(
                'assets/launcher.png',
              ),
            )),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      "Confirm Transaction",
                      style: TextStyle(fontSize: 20),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(1);
                      },
                      child: const Row(
                          children: [Icon(Icons.close), Text("Cancel")]),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Form(
                    key: formKey,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: formItems.length,
                        padding: const EdgeInsets.only(left: 14, right: 14),
                        itemBuilder: (context, index) {
                          return BaseFormComponent(
                              formItem: formItems[index],
                              moduleItem: moduleItem,
                              formItems: formItems,
                              formKey: formKey,
                              child:
                                  IFormWidget(formItems[index], jsonText: input)
                                      .render());
                        })),
                const Spacer(),
                SizedBox(
                    width: 300,
                    child: WidgetFactory.buildButton(context, () {
                      Navigator.of(context).pop(0);
                    }, "Confirm".toUpperCase())),
                const SizedBox(
                  height: 44,
                )
              ],
            ));
      },
    );
  }
}
