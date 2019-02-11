
void log(e, String type) {
  if (type == 'Exception')
    print('Exception log: => Code: ${e.code}\nMessage: ${e.message}');
  else if (type == 'camera')
    print('Camera log: => Code: $e');
  else if (type == 'video')
    print('Video log: => Code: $e');
  else if (type == 'saveVideo')
    print('Svae video log: => Code: ${e.code}\nMessage: ${e.message}');
  else if (type == 'state')
    print('State log: => Code: $e');
  else
    print(e);
}
