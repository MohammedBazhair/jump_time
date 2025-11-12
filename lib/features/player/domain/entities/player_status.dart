enum PlayerStatus {
  playing('يلعب'),
  resumed('متوقف مؤقتا'),
  finished('انتهى'),
  waiting('ينتظر'),
  ready('جاهز');

  const PlayerStatus(this.status);
  final String status;

  bool get isPlaying => this == playing;
  bool get isFinishid => this == finished;
  bool get isResumed => this == resumed;
}
