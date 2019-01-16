export default function printAsMoney(euroValue) {
  const REWARD_IS_MONEY = false;
  const SIGN = ' punten';
  const SIGN_SINGULAR = ' punt';
  const FRONT_PLACEMENT = false;

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
