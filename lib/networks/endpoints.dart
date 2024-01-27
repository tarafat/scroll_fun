// ignore_for_file: constant_identifier_names

const String url = "https://api.github.com/repos";

final class NetworkConstants {
  NetworkConstants._();

  static const ACCEPT = "Accept";
  static const X_GITHUB_API_VERSION = "X-GitHub-Api-Version";
  static const ACCEPT_TYPE = "application/vnd.github+json";
  static const API_VERSION = "2022-11-28";
}

final class Endpoints {
  Endpoints._();

  static String getIssues(String owner, String repo, String perPage,
          [int? page = 1, String? filter = ""]) =>
      "/$owner/$repo/issues?per_page=$perPage&page=$page&labels=$filter";
  static String getlabels(String owner, String repo) => "/$owner/$repo/labels";
}
