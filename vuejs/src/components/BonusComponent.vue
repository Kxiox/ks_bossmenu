<script setup>
    defineProps({
        employees: {
            type: Number,
            default: 0
        },

        onDuty: {
            type: Number,
            default: 0
        },

        account: {
            type: String,
            default: '0'
        },

        actions: {
            type: Array,
            default: () => []
        },

        currency: {
            type: String,
            default: null
        }
    });
</script>

<template>
    <h1 class="text-start">{{ $t('pages.bonus') }}</h1>

    <hr>

    <div class="form-check form-switch">
        <input class="form-check-input" type="checkbox" role="switch" id="switchCheckDefault">
        <label class="form-check-label" for="switchCheckDefault">Default switch checkbox input</label>
    </div>
</template>

<style scoped lang="scss">
    @use 'bootstrap/scss/bootstrap' as *;

    h1 {
        font-size: 1.7rem;
        margin-bottom: 20px;
        text-align: center;
    }

    .btn-primary {
        background-color: var(--color-500);
        border: none !important;
        box-shadow: none !important;

        &:hover {
            background-color: var(--color-600);
        }

        &:active {
            background-color: var(--color-700) !important;
            color: #fff !important;
            border: none !important;
            box-shadow: none !important;
        }
    }

    ::-webkit-scrollbar {
        width: 0.2rem;
        height: 0.5rem;
    }
        
    ::-webkit-scrollbar-thumb {
        background: var(--color-400);
        border-radius: 10px;
    }
</style>