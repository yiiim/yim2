import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:yim2/ui/widgets/loading.dart';

class YimScaffoldToastController extends ChangeNotifier {
  int _toastNumber = 0;
  Duration showDuration = const Duration(seconds: 2);
  Duration toastAnimationDuration = const Duration(milliseconds: 300);
  String? toastMsg;
  bool get isShowToast => _toastNumber > 0;

  Future showToast(String msg) async {
    _toastNumber++;
    toastMsg = msg;
    notifyListeners();
    await Future.delayed(showDuration);
    toastMsg = null;
    _toastNumber--;
    notifyListeners();
  }
}

class YimScaffoldLoadingController extends ChangeNotifier {
  YimScaffoldLoadingController();

  bool _animation = false;
  bool _isLoading = false;
  String? _loadingText = "";
  bool get isLoading => _isLoading;
  bool get animation => _animation;
  String? get loadingText => _loadingText;

  void showLoading({String? msg, bool animation = true}) {
    _animation = animation;
    _isLoading = true;
    _loadingText = msg;
    notifyListeners();
  }

  void hideLoading({bool animation = true}) {
    _animation = animation;
    _isLoading = false;
    notifyListeners();
  }
}

class YimScaffold extends StatefulWidget {
  final YimScaffoldLoadingController? loadingController;
  final YimScaffoldToastController? toastController;
  final Widget Function(BuildContext context, Animation<double> animation, String? text)? loadingBuilder;
  final Widget? body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final List<Widget>? persistentFooterButtons;
  final Widget? drawer;
  final void Function(bool)? onDrawerChanged;
  final Widget? endDrawer;
  final void Function(bool)? onEndDrawerChanged;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final bool primary;
  final DragStartBehavior drawerDragStartBehavior;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final Color? drawerScrimColor;
  final double? drawerEdgeDragWidth;
  final bool drawerEnableOpenDragGesture;
  final bool endDrawerEnableOpenDragGesture;
  final String? restorationId;
  final Key? scaffoldKey;
  const YimScaffold({
    this.loadingController,
    this.toastController,
    this.loadingBuilder,
    this.body,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.drawer,
    this.onDrawerChanged,
    this.endDrawer,
    this.onEndDrawerChanged,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.primary = true,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
    this.restorationId,
    this.scaffoldKey,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => YimScaffoldState();
}

class YimScaffoldState extends State<YimScaffold> with TickerProviderStateMixin {
  late AnimationController _loadingAnimationController;
  late AnimationController _toastAnimationController;

  Widget _buildLoading(BuildContext context) {
    if (widget.loadingBuilder != null) return widget.loadingBuilder!(context, _loadingAnimationController, widget.loadingController?.loadingText);
    return FadeTransition(
      opacity: _loadingAnimationController,
      alwaysIncludeSemantics: true,
      child: Container(
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.2)),
        alignment: Alignment.center,
        child: AnimatedBuilder(
          animation: _loadingAnimationController,
          builder: (context, child) => YimLoading(
            text: widget.loadingController?.loadingText ?? "",
            textStyle: Theme.of(context).textTheme.bodyText2,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      behavior: HitTestBehavior.translucent,
      child: Stack(
        children: [
          if (widget.body != null) widget.body!,
          AnimatedBuilder(
            animation: _loadingAnimationController,
            child: _buildLoading(context),
            builder: (context, child) {
              return Visibility(visible: _loadingAnimationController.value > 0, child: child!);
            },
          ),
          AnimatedBuilder(
            animation: _toastAnimationController,
            child: Container(
              decoration: const BoxDecoration(color: Colors.transparent),
              alignment: Alignment.center,
              child: LayoutBuilder(
                builder: (context, view) {
                  return FadeTransition(
                    opacity: CurvedAnimation(parent: _toastAnimationController, curve: Curves.easeIn),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      constraints: BoxConstraints(maxWidth: view.maxWidth * 0.8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        widget.toastController?.toastMsg ?? "",
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
            ),
            builder: (context, child) {
              return Visibility(visible: _toastAnimationController.value > 0, child: child!);
            },
          ),
        ],
      ),
    );
  }

  void _loadingControllerListener() {
    if (!mounted) return;
    if (widget.loadingController == null) return;
    widget.loadingController!.animation
        ? _loadingAnimationController.animateTo(widget.loadingController!.isLoading ? 1 : 0, duration: const Duration(milliseconds: 300))
        : setState(
            () => _loadingAnimationController.value = widget.loadingController!.isLoading ? 1 : 0,
          );
  }

  void _toastControllerListen() {
    if (!mounted) return;
    if (widget.toastController == null) return;
    _toastAnimationController.animateTo(widget.toastController!.isShowToast ? 1 : 0, duration: widget.toastController!.toastAnimationDuration);
  }

  @override
  void didUpdateWidget(covariant YimScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.toastController != oldWidget.toastController) {
      oldWidget.toastController?.removeListener(_toastControllerListen);
      widget.toastController?.addListener(_toastControllerListen);
    }
    if (widget.loadingController != oldWidget.loadingController) {
      oldWidget.loadingController?.removeListener(_loadingControllerListener);
      widget.loadingController?.addListener(_loadingControllerListener);
    }
  }

  @override
  void dispose() {
    if (widget.loadingController != null) widget.loadingController!.removeListener(_loadingControllerListener);
    if (widget.toastController != null) widget.toastController!.removeListener(_toastControllerListen);
    _loadingAnimationController.stop();
    _loadingAnimationController.dispose();
    _toastAnimationController.stop();
    _toastAnimationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadingAnimationController = AnimationController(vsync: this, value: 0);
    if (widget.loadingController != null) widget.loadingController!.addListener(_loadingControllerListener);
    _toastAnimationController = AnimationController(vsync: this, value: 0);
    if (widget.toastController != null) widget.toastController!.addListener(_toastControllerListen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.scaffoldKey,
      appBar: widget.appBar,
      body: _buildBody(context),
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
      persistentFooterButtons: widget.persistentFooterButtons,
      drawer: widget.drawer,
      onDrawerChanged: widget.onDrawerChanged,
      endDrawer: widget.endDrawer,
      onEndDrawerChanged: widget.onEndDrawerChanged,
      bottomNavigationBar: widget.bottomNavigationBar,
      bottomSheet: widget.bottomSheet,
      backgroundColor: widget.backgroundColor ?? Theme.of(context).backgroundColor,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      primary: widget.primary,
      drawerDragStartBehavior: widget.drawerDragStartBehavior,
      extendBody: widget.extendBody,
      extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
      drawerScrimColor: widget.drawerScrimColor,
      drawerEdgeDragWidth: widget.drawerEdgeDragWidth,
      drawerEnableOpenDragGesture: widget.drawerEnableOpenDragGesture,
      endDrawerEnableOpenDragGesture: widget.endDrawerEnableOpenDragGesture,
      restorationId: widget.restorationId,
    );
  }
}
