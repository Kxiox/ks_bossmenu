import translations from '../../public/en.json'

export function t(key, params = {}) {
  let str = key.split('.').reduce((o, i) => (o ? o[i] : key), translations)

  Object.entries(params).forEach(([k, v]) => {
    str = str.replace(new RegExp(`{${k}}`, 'g'), v)
  })
  
  return str
}