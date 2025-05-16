import './assets/main.css'

import 'bootstrap/scss/bootstrap.scss';
import 'bootstrap-icons/font/bootstrap-icons.css';

import bootstrap from 'bootstrap/dist/js/bootstrap.bundle.js'

import { createApp } from 'vue'
import App from './App.vue'

import { Bar } from 'vue-chartjs'

const app = createApp(App).use(bootstrap)

app.mount('#app')

window.addEventListener('message', (event) => {
    if (event.data.action === 'showMessage') {
        console.log('Message from FiveM client:', event.data.message)
    }
})

function sendMessagetoClient(message) {
    fetch(`https://${GetParentResourceName()}/exampleCallback`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8'
        },
        body: JSON.stringify({
            message: message
        })
    }).then(response => response.json())
        .then(data => {
            console.log('Response from FiveM client:', data)
        })
}
