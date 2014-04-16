var SelectText;

SelectText = function(element) {
  var doc, range, selection, text;
  doc = document;
  text = doc.getElementById(element);
  range = void 0;
  selection = void 0;
  if (doc.body.createTextRange) {
    range = document.body.createTextRange();
    range.moveToElementText(text);
    range.select();
  } else if (window.getSelection) {
    selection = window.getSelection();
    range = document.createRange();
    range.selectNodeContents(text);
    selection.removeAllRanges();
    selection.addRange(range);
  }
};