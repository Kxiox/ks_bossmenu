// Translation system that works in both development and production build
const translations = {};
let currentLocale = 'de';
const availableLocales = ['de', 'en']; // Will be updated dynamically
const localeCache = {};
let isInitialized = false;

// Event system for translation updates
const translationEvents = new EventTarget();

// Function to load locale dynamically (works in build)
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

// Function to discover available locales by trying common ones
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
      // Locale doesn't exist, skip
    }
  }

  availableLocales.splice(0, availableLocales.length, ...discovered);
  console.log('Discovered available locales:', availableLocales);
  return discovered;
}

// Initialize with default locale
async function initializeTranslations() {
  await discoverAvailableLocales();
  
  // Priority: de -> en -> first available
  let localeToLoad = 'de';
  if (!availableLocales.includes('de') && availableLocales.includes('en')) {
    localeToLoad = 'en';
  } else if (!availableLocales.includes('de') && !availableLocales.includes('en') && availableLocales.length > 0) {
    localeToLoad = availableLocales[0];
  }

  const localeData = await loadLocale(localeToLoad);
  if (localeData) {
    currentLocale = localeToLoad;
    Object.assign(translations, localeData);
    isInitialized = true;
    console.log('Initialized with locale:', currentLocale);
    
    // Notify that translations are ready
    translationEvents.dispatchEvent(new CustomEvent('translationsReady', {
      detail: { locale: currentLocale, translations }
    }));
  }
}

// Initialize immediately
initializeTranslations();

// Listen for locale changes
window.addEventListener('message', (event) => {
  if (event.data.action === 'setLocale') {
    setLocale(event.data.locale);
  }
});

// Function to change locale
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
    console.log('Locale changed to:', locale);
    
    // Notify that translations changed
    translationEvents.dispatchEvent(new CustomEvent('translationsChanged', {
      detail: { locale: currentLocale, translations }
    }));
    
    return true;
  }
  return false;
}

// Debug function for manual locale switching
window.setLocale = function(locale) {
  return setLocale(locale);
};

// Utility function to get all available locales
window.getAvailableLocales = function() {
  return [...availableLocales];
};

// Utility function to get current locale
window.getCurrentLocale = function() {
  return currentLocale;
};

// Utility function to refresh available locales (useful after adding new files)
window.refreshLocales = async function() {
  await discoverAvailableLocales();
  return availableLocales;
};

// Utility function to check if translations are ready
window.isTranslationsReady = function() {
  return isInitialized;
};

// Utility function to wait for translations to be ready
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
  // If translations are not loaded yet, return the key as fallback
  if (!isInitialized || Object.keys(translations).length === 0) {
    console.warn('Translations not loaded yet, returning key:', key);
    return key;
  }

  let str = key.split('.').reduce((o, i) => (o ? o[i] : key), translations);
  
  // If translation not found, return the key
  if (str === key && !translations[key.split('.')[0]]) {
    console.warn('Translation not found for key:', key);
    return key;
  }

  Object.entries(params).forEach(([k, v]) => {
    str = str.replace(new RegExp(`{${k}}`, 'g'), v);
  });
  
  return str;
}