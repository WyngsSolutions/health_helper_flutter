import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';

class WebViewScreen extends StatefulWidget {

  final String name;
  final String url;
  const WebViewScreen({super.key, required this.url, required this.name});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {

  final _key = UniqueKey();
  late WebViewController controller;
  String websiteLink = "";
  bool isFirstPage = true;
  String currentUrl = "";

  @override
  void initState() {
    super.initState();
    websiteLink = widget.url;
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Constants.appThemeColor,
        centerTitle: true,
        title: Text(
          widget.name,
          style: TextStyle(
            color: Colors.white,
            fontSize: SizeConfig.fontSize*2.2
          ),
        ),
      ),
      body: Container(
        child: WebView(
          key: _key,
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: websiteLink,
          onWebViewCreated: (WebViewController webViewController){
            controller = webViewController;
          },
          navigationDelegate: (NavigationRequest request){
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url){
            currentUrl = url;
          },
          onPageFinished: (String url){
            currentUrl = url;
          },
        ),
      ),
    );
  }
}