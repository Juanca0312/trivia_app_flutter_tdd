enum RequestProgressStatus {
  nothing,
  loading,
  success,
  error,
}

extension RequestProgressStatusExtension on RequestProgressStatus {
  bool get isNothing => this == RequestProgressStatus.nothing;
  bool get isLoading => this == RequestProgressStatus.loading;
  bool get isSuccess => this == RequestProgressStatus.success;
  bool get isError => this == RequestProgressStatus.error;
}
