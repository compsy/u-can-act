export function printAsMoney(euroValue) {
  const REWARD_IS_MONEY = true;
  const SIGN = ' punten';
  const SIGN_SINGULAR = ' punt';
  const FRONT_PLACEMENT = false;

  if (REWARD_IS_MONEY) return printAsEuros(euroValue)

  const precision = 2;
  const oneHundredPercent = 100;
  const isSingular = 1;
  const sign = euroValue === isSingular ? SIGN_SINGULAR : SIGN;

  let updatedEuroValue = parseFloat(Math.round(euroValue * oneHundredPercent) / oneHundredPercent).toFixed(precision);
  updatedEuroValue = updatedEuroValue.toString();
  updatedEuroValue = updatedEuroValue.replace('.', ',');

  if (REWARD_IS_MONEY) {
    updatedEuroValue = updatedEuroValue.replace(',00', ',-');
  } else {
    updatedEuroValue = updatedEuroValue.replace(',00', '');
  }

  if (FRONT_PLACEMENT) {
    return sign + updatedEuroValue;
  }
  return updatedEuroValue + sign;
}

export function printAsEuros(euroValue) {
  euroValue = parseFloat(Math.round(euroValue * 100) / 100).toFixed(2);
  euroValue = euroValue.toString();
  euroValue = euroValue.replace('.', ',');
  euroValue = euroValue.replace(',00', ',-');
  euroValue = '€' + euroValue;
  return (euroValue);
}
