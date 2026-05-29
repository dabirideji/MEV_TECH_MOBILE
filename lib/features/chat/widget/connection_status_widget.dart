import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:signalr_netcore/hub_connection.dart';


class ConnectionStatusWidget extends StatefulWidget {
  const ConnectionStatusWidget(this.status, {super.key});
  final HubConnectionState? status;

  @override
  State<ConnectionStatusWidget> createState() => _ConnectionStatusWidgetState();
}

class _ConnectionStatusWidgetState extends State<ConnectionStatusWidget> {
  @override
  Widget build(BuildContext context) {
    // log(status.name);

    if (widget.status != null &&
        widget.status == HubConnectionState.Connected) {
      return Container(
        padding: EdgeInsets.all(2.r),
        decoration: BoxDecoration(
          color: Colors.green.shade100,
          borderRadius: BorderRadius.circular(360),
        ),
        child: Icon(Icons.language_rounded,color: Colors.green.shade800,size: 30,),
      );
    } else if (widget.status != null &&
        widget.status == HubConnectionState.Connecting) {
      return Container(
        padding: EdgeInsets.all(2.r),
        decoration: BoxDecoration(
          color: Colors.orange.shade100,
          borderRadius: BorderRadius.circular(360),
        ),
        child: Icon(Icons.language_rounded,color: Colors.orange.shade600,size: 30,),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(2.r),
        decoration: BoxDecoration(
          color: Colors.red.shade100,
          borderRadius: BorderRadius.circular(360),
        ),
        child: Icon(Icons.language_rounded,color: Colors.red.shade800,size: 30,),
      );
    }
  }
}
