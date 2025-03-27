class ApiResponseHandler {
  static Map<String, dynamic> output(uriResponse) {
    Map<String, dynamic> res = Map<String, dynamic>();
    if (uriResponse.statusCode == 200 || uriResponse.statusCode == 201) {
      res["statusCode"] = uriResponse.statusCode;
      res["result"] = uriResponse.body;
      res["error"] = null;
    } else if (uriResponse.statusCode >= 400 && uriResponse.statusCode <= 500) {
      res["statusCode"] = uriResponse.statusCode;
      res["result"] = null;
      res["error"] = uriResponse.body;
    } else {
      res["statusCode"] = uriResponse.statusCode;
      res["result"] = null;
      res["error"] = "Something went wrong";
    }

    return res;
  }

  static Map<String, dynamic> outputError() {
    Map<String, dynamic> res = Map<String, dynamic>();
    res["result"] = null;
    res["statusCode"] = 500;
    res["error"] = "Something went wrong";
    return res;
  }

  static Map<String, dynamic> socketConnectionError() {
    Map<String, dynamic> res = Map<String, dynamic>();
    res["result"] = null;
    res["statusCode"] = 502;
    res["error"] = "Failed to connect with server";
    return res;
  }

  static Map<String, dynamic> localOutput(uriResponse, key) {
    Map<String, dynamic> res = Map<String, dynamic>();
    if (uriResponse["statusCode"] == 200 || uriResponse["statusCode"] == 201) {
      res["statusCode"] = uriResponse["statusCode"];
      res["result"] = uriResponse[key];
      res["error"] = null;
    } else if (uriResponse["statusCode"] >= 400 &&
        uriResponse["statusCode"] <= 500) {
      res["statusCode"] = uriResponse["statusCode"];
      res["result"] = null;
      res["error"] = uriResponse["error"];
    } else {
      res["statusCode"] = uriResponse["statusCode"];
      res["result"] = null;
      res["error"] = "Something went wrong";
    }

    return res;
  }

  static Map<String, dynamic> localOutputError() {
    Map<String, dynamic> res = Map<String, dynamic>();
    res["result"] = null;
    res["statusCode"] = 500;
    res["error"] = "Something went wrong";
    return res;
  }
}
