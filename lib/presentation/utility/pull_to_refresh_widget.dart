
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PullToRefreshWidget extends StatefulWidget {
  final Future<void> Function() onRefresh;
  final Widget child;
  const PullToRefreshWidget({
    super.key,
    required this.onRefresh,
    required this.child,
  });

  @override
  State<PullToRefreshWidget> createState() => _PullToRefreshWidgetState();
}

class _PullToRefreshWidgetState extends State<PullToRefreshWidget> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  Future<void> _checkInternetRefresh(context) async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.wifi) || connectivityResult.contains(ConnectivityResult.mobile)) {
      await widget.onRefresh();
      _refreshController.refreshCompleted();
    } else {
      _refreshController.refreshFailed();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Internet Connection')),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: () => _checkInternetRefresh(context),
      child: widget.child,
    );
  }
}

class TestPullRefreshPage extends StatefulWidget {
  const TestPullRefreshPage({super.key});

  @override
  State<TestPullRefreshPage> createState() => _TestPullRefreshPageState();
}

class _TestPullRefreshPageState extends State<TestPullRefreshPage> {

  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  Future<void> _refreshInternetConnection() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      //LOGIC HERE
    });
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test pull to refresh'),
      ),
      body: SmartRefresher(
        onRefresh: _refreshInternetConnection,
        controller: _refreshController,
        child: const Center(
          child: Text('TEXT'),
        )
      ),
    );
  }
}

