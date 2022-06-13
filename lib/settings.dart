
bool debug = false;

String debugHost = "https://ready-peaches-cover-195-88-139-252.loca.lt";
String prodHost = "http://164.90.198.17";

String host = debug ? debugHost : prodHost;
String api = "$host/api";
