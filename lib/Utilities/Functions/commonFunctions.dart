class WaveFunctions {
  reverseDate({required String date}) {
    var dt, temp;
    temp = date.split('-');
    if (temp.length == 3) {
      dt = '${temp[2]}-${temp[1]}-${temp[0]}';
    } else {
      dt = date;
    }
    return dt;
  }
}
