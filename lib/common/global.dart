import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const String appName = "Teddy Bear's diary";
late Size mq;
final OPENAI_APIKEY = dotenv.env['OPENAI_API_KEY'];
final Server_Client_ID = dotenv.env['SERVER_CLIENT_ID'];