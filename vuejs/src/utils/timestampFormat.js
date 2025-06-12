let timestampFormat = 'us' // Default

window.addEventListener('message', (event) => {
    if (event.data.action === 'setTimestampFormat') {
        setTimestampFormat(event.data.format)
    }
})

function setTimestampFormat(format) {
    timestampFormat = format
}

/**
 * @param {number} unix
 * @returns {string}
**/

export function formatTimestamp(unix) {
    const date = new Date(unix * 1000)
    switch (timestampFormat) {
        case 'us':
            return date.toLocaleString('en-US', {
                day: '2-digit', month: 'short', year: 'numeric',
                hour: '2-digit', minute: '2-digit'
            })
        case 'de':
            return date.toLocaleString('de-DE', {
                day: '2-digit', month: 'short', year: 'numeric',
                hour: '2-digit', minute: '2-digit'
            })
        case 'iso':
            return date.toISOString().replace('T', ' ').substring(0, 16)
        case 'uk':
            return date.toLocaleString('en-GB', {
                day: '2-digit', month: 'short', year: 'numeric',
                hour: '2-digit', minute: '2-digit'
            })
        case 'fr':
            return date.toLocaleString('fr-FR', {
                day: '2-digit', month: 'short', year: 'numeric',
                hour: '2-digit', minute: '2-digit'
            })
        default:
            return date.toLocaleString()
    }
}