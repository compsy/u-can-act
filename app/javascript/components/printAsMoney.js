export default function printAsMoney(euroValue) {
  euroValue = parseFloat(Math.round(euroValue * 100) / 100).toFixed(2);
  euroValue = euroValue.toString();
  euroValue = euroValue.replace('.',',');
  euroValue = euroValue.replace(',00',',-');
  euroValue = '€' + euroValue;
  return(euroValue);
}
