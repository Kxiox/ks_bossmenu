const translations = {};
let currentLocale = 'en';
const availableLocales = ['de', 'en', 'fr']; // Will be updated dynamically
const localeCache = {};
let isInitialized = false;

const translationEvents = new EventTarget();

async function loadLocale(locale) {
  if (localeCache[locale]) {
    return localeCache[locale];
  }

  try {
    const response = await fetch(`./locales/${locale}.json`);
    if (!response.ok) {
      throw new Error(`Locale ${locale} not found`);
    }
    const data = await response.json();
    localeCache[locale] = data;
    return data;
  } catch (error) {
    console.error(`Failed to load locale ${locale}:`, error);
    return null;
  }
}

async function discoverAvailableLocales() {
  const commonLocales = ['de', 'en', 'fr', 'es', 'it', 'nl', 'pl', 'pt', 'ru', 'tr', 'cs', 'sk', 'hu', 'ro', 'bg', 'hr', 'sl', 'lv', 'lt', 'et', 'fi', 'sv', 'da', 'no', 'is'];
  const discovered = [];

  for (const locale of commonLocales) {
    try {
      const response = await fetch(`./locales/${locale}.json`);
      if (response.ok) {
        discovered.push(locale);
      }
    } catch (error) {
    }
  }

  availableLocales.splice(0, availableLocales.length, ...discovered);
  return discovered;
}

async function initializeTranslations() {
  await discoverAvailableLocales();
  
  let localeToLoad = 'en';
  if (!availableLocales.includes('en') && availableLocales.includes('de')) {
    localeToLoad = 'de';
  } else if (!availableLocales.includes('en') && !availableLocales.includes('de') && availableLocales.length > 0) {
    localeToLoad = availableLocales[0];
  }

  const localeData = await loadLocale(localeToLoad);
  if (localeData) {
    currentLocale = localeToLoad;
    Object.assign(translations, localeData);
    isInitialized = true;
    
    translationEvents.dispatchEvent(new CustomEvent('translationsReady', {
      detail: { locale: currentLocale, translations }
    }));
  }
}

initializeTranslations();

window.addEventListener('message', (event) => {
  if (event.data.action === 'setLocale') {
    setLocale(event.data.locale);
  }
});

async function setLocale(locale) {
  if (!availableLocales.includes(locale)) {
    console.error('Locale not available:', locale, 'Available locales:', availableLocales);
    return false;
  }

  const localeData = await loadLocale(locale);
  if (localeData) {
    currentLocale = locale;
    Object.keys(translations).forEach(key => delete translations[key]);
    Object.assign(translations, localeData);
    
    translationEvents.dispatchEvent(new CustomEvent('translationsChanged', {
      detail: { locale: currentLocale, translations }
    }));
    
    return true;
  }
  return false;
}

window.setLocale = function(locale) {
  return setLocale(locale);
};

window.getAvailableLocales = function() {
  return [...availableLocales];
};

window.getCurrentLocale = function() {
  return currentLocale;
};

window.refreshLocales = async function() {
  await discoverAvailableLocales();
  return availableLocales;
};

window.isTranslationsReady = function() {
  return isInitialized;
};

window.waitForTranslations = function() {
  return new Promise((resolve) => {
    if (isInitialized) {
      resolve(translations);
    } else {
      translationEvents.addEventListener('translationsReady', (event) => {
        resolve(event.detail.translations);
      }, { once: true });
    }
  });
};

export function t(key, params = {}) {
  if (!isInitialized || Object.keys(translations).length === 0) {
    return key;
  }

  let str = key.split('.').reduce((o, i) => (o ? o[i] : key), translations);
  
  if (str === key && !translations[key.split('.')[0]]) {
    return key;
  }

  Object.entries(params).forEach(([k, v]) => {
    str = str.replace(new RegExp(`{${k}}`, 'g'), v);
  });
  
  return str;
}