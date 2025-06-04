<template>
    <transition-group
        name="notify-slide"
        tag="div"
        class="notify-container"
    >
        <div v-for="(alert, index) in alerts" :key="index"
            :class="['alert', alertClass(alert.type), 'd-flex', 'align-items-center', 'mb-2']" role="alert">
            <i :class="[
                'me-2',
                alert.type === 'success' ? 'bi bi-check-circle-fill' :
                    alert.type === 'warning' ? 'bi bi-exclamation-triangle-fill' :
                        alert.type === 'danger' ? 'bi bi-exclamation-triangle-fill' :
                            'bi bi-info-circle-fill'
            ]" style="font-size: 1rem;"></i>
            <div>{{ alert.message }}</div>
        </div>
    </transition-group>
</template>

<script setup>
import { ref } from 'vue'

const alerts = ref([])

function triggerAlert(type, message) {
    alerts.value.push({ type, message })
    setTimeout(() => {
        alerts.value.shift()
    }, 3000)
}

function alertClass(type) {
    return {
        info: 'alert-primary',
        success: 'alert-success',
        warning: 'alert-warning',
        danger: 'alert-danger'
    }[type] || 'alert-primary'
}

defineExpose({ triggerAlert })
</script>

<style scoped>
    .notify-container {
        position: fixed;
        top: 30px;
        left: 50%;
        transform: translateX(-50%);
        z-index: 99999;
        pointer-events: none;
        display: flex;
        flex-direction: column;
        align-items: center;
    }

    /* Transition classes for slide from top and back up */
    .notify-slide-enter-from,
    .notify-slide-leave-to {
        opacity: 0;
        transform: translateY(-40px) scale(0.95);
    }

    .notify-slide-enter-active,
    .notify-slide-leave-active {
        transition: all 0.4s cubic-bezier(.4, 0, .2, 1);
    }

    .notify-slide-enter-to,
    .notify-slide-leave-from {
        opacity: 1;
        transform: translateY(0) scale(1);
    }

    .alert {
        pointer-events: none;
        height: 3rem;
    }
</style>
