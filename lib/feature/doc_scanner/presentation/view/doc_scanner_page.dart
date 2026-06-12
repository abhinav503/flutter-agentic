import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base/base_page.dart';
import '../../../../core/constants/value_const.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/ui/atoms/top_bar.dart';
import '../../../../core/ui/molecules/bottom_sheet.dart';
import '../bloc/doc_scanner_bloc.dart';
import '../bloc/model_selector_cubit.dart';
import '../widgets/model_selector_sheet.dart';
import 'doc_scanner_screen.dart';

class DocScannerPage extends BasePage {
  const DocScannerPage({super.key});

  @override
  State<DocScannerPage> createState() => _DocScannerPageState();
}

class _DocScannerPageState extends BasePageState<DocScannerPage> {
  @override
  Widget buildBlocProviders(Widget child) => BlocProvider(
        create: (_) => ModelSelectorCubit(
          getSelectedModelUseCase: sl(),
          selectModelUseCase: sl(),
          getApiKeysUseCase: sl(),
          saveApiKeyUseCase: sl(),
        ),
        child: child,
      );

  @override
  PreferredSizeWidget buildAppBar(BuildContext context) =>
      AppTopBar.primary(
        title: ValueConst.docScannerAppBarTitle,
        actions: [
          IconButton(
            tooltip: ValueConst.docScannerModelSelectorTooltip,
            icon: const Icon(Icons.tune_rounded),
            onPressed: () => AppBottomSheet.show(
              context,
              title: ValueConst.docScannerModelSelectorTitle,
              child: BlocProvider.value(
                value: context.read<ModelSelectorCubit>(),
                child: const ModelSelectorSheetContent(),
              ),
            ),
          ),
        ],
      );

  @override
  Widget buildBody(BuildContext context) => BlocProvider(
        create: (_) => DocScannerBloc(
          resolveImageUseCase: sl(),
          scanReceiptUseCase: sl(),
          generatePdfUseCase: sl(),
          loadReceiptsUseCase: sl(),
          saveReceiptUseCase: sl(),
          editReceiptUseCase: sl(),
          deleteReceiptUseCase: sl(),
          modelSelectorCubit: context.read<ModelSelectorCubit>(),
        )..add(const DocScannerEvent.started()),
        child: const DocScannerScreen(),
      );
}
