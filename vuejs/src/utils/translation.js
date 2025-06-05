import translations from '../../public/en.json'

export function t(key) {
  return key.split('.').reduce((o, i) => (o ? o[i] : key), translations)
}