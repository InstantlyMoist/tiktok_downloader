class URLChecker {

  static bool isURLValid(String url) {
    if (url.isEmpty) return false;
    if (!Uri.parse(url).isAbsolute) return false;
    if (!url.startsWith("https://vm.tiktok.com/")) return false;
    return true;
  }

}