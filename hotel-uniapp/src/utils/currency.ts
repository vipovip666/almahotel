export const formatMoney = (cents: number, currency: string = 'CNY') => {
  const amount = cents / 100
  try { return new Intl.NumberFormat(undefined, { style: 'currency', currency }).format(amount) } catch { return `${amount.toFixed(2)} ${currency}` }
}