const translations = {};

window.addEventListener('message', (event) => {
  if (event.data.action === 'setLocale') {
    console.log('Setting locale to:', event.data.locale)
    import(`../../public/locales/${event.data.locale}.json`)
      .then(module => {
        Object.assign(translations, module.default || module)
        console.log('Loaded translations:', translations)
      })
      .catch(err => {
        console.error('Failed to load locale:', err)
      })
  }
})

export function t(key, params = {}) {
  let str = key.split('.').reduce((o, i) => (o ? o[i] : key), translations)

  Object.entries(params).forEach(([k, v]) => {
    str = str.replace(new RegExp(`{${k}}`, 'g'), v)
  })
  
  return str
}