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
        }
    });
</script>

<template>
    <h1 class="text-start">{{ $t('pages.home') }}</h1>

    <hr>

    <div class="info-section">
        <h4>{{ $t('home.stats') }}</h4>
        <div class="row">
            <div class="col">
                <div class="stats-section">
                    <div class="container">
                        <div class="row g-0">
                            <div class="col-6 col-md-4">
                                <i class="bi bi-people" style="font-size: 225%;"></i>
                            </div>

                            <div class="col-sm-6 col-md-8">
                                <h5>{{ $t('home.employees') }}:</h5>
                                <h6 id="employeesamount">{{ employees }}</h6>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col">
                <div class="stats-section">
                    <div class="container">
                        <div class="row g-0">
                            <div class="col-6 col-md-4">
                                <i class="bi bi-person-check" style="font-size: 225%;"></i>
                            </div>
                            <div class="col-sm-6 col-md-8">
                                <h5>{{ $t('home.on_duty') }}:</h5>
                                <h6 id="onDuty">{{ onDuty }}</h6>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col">
                <div class="stats-section">
                    <div class="container">
                        <div class="row g-0">
                            <div class="col-6 col-md-4">
                                <i class="bi bi-bank" style="font-size: 225%;"></i>
                            </div>

                            <div class="col-sm-6 col-md-8">
                                <h5>{{ $t('home.account') }}:</h5>
                                <h6 id="account">{{ account }}</h6>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <h4 class="mt-3">
            {{ $t('home.last_actions') }}
            <button class="btn btn-primary"
                style="--bs-btn-padding-y: .25rem; --bs-btn-padding-x: .5rem; --bs-btn-font-size: .6rem;"
                @click="$emit('see-all-actions')">
                {{ $t('buttons.see_all') }}
            </button>
        </h4>

        <table class="table table-striped table-hover">
            <thead>
                <tr>
                    <th><b>#</b></th>
                    <th><b>{{ $t('home.table_action') }}</b></th>
                    <th><b>{{ $t('home.table_employee') }}</b></th>
                    <th><b>{{ $t('home.table_time') }}</b></th>
                </tr>
            </thead>
            <tbody class="table-group-divider">
                <tr v-for="(action, i) in actions.slice().sort((a, b) => b.id - a.id).slice(0, 4)" :key="i">
                    <td>{{ action.id }}</td>
                    <td>{{ action.action }}</td>
                    <td>{{ action.employee }}</td>
                    <td>{{ new Date(action.time * 1000).toLocaleString('en-US', { day: '2-digit', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit' }) }}</td>
                </tr>
            </tbody>
        </table>
    </div>
</template>

<style scoped lang="scss">
    @use 'bootstrap/scss/bootstrap' as *;

    h1 {
        font-size: 1.7rem;
        margin-bottom: 20px;
        text-align: center;
    }

    .info-section {
        flex: 1;
        color: var(--color-200);
        display: flex;
        flex-direction: column;
        gap: 1rem;
    }

    .stats-section,
    .additional-info {
        background-color: #ffffff10;
        border-radius: 1rem;
        padding: 1rem;
        color: var(--color-500);

        h5 {
            color: white;
        }
        
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

    tbody {
        color: #fff;
    }
</style>