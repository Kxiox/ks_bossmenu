import { ref, getCurrentInstance } from 'vue'

// Global state for translations - shared across all components
const translationsReady = ref(false)
let initializationPromise = null

// Initialize translations only once globally
async function initializeTranslations() {
    if (initializationPromise) {
        return initializationPromise
    }

    initializationPromise = new Promise(async (resolve) => {
        if (window.isTranslationsReady && window.isTranslationsReady()) {
            translationsReady.value = true
            resolve()
        } else if (window.waitForTranslations) {
            await window.waitForTranslations()
            translationsReady.value = true
            resolve()
        } else {
            setTimeout(() => {
                translationsReady.value = true
                resolve()
            }, 500)
        }
    })

    return initializationPromise
}

export function useTranslations() {
    const { proxy } = getCurrentInstance()
    const $t = proxy.$t

    // Start initialization if not already started
    if (!initializationPromise) {
        initializeTranslations()
    }

    return {
        translationsReady,
        $t,
        initializeTranslations
    }
}
