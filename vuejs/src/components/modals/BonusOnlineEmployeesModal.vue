<script setup>
import { useTranslations } from '../../composables/useTranslations.js'

const { $t } = useTranslations()

const props = defineProps({
    notifiesRef: Object,
    currency: {
        type: String,
        default: null
    },
    onlineEmployees: {
        type: Array,
        default: () => []
    }
})

function giveBonusToOnlineEmployees() {
    const bonusAmount = parseInt(document.getElementById('bonusOnlineEmployeesAmount').value)
    if (!bonusAmount || bonusAmount <= 0) {
        props.notifiesRef?.triggerAlert('warning', $t('notifies.bonus.invalid_amount'))
        return
    }

    console.log('Giving bonus to online employees:', bonusAmount)
    props.notifiesRef?.triggerAlert('success', $t('notifies.bonus.online_employees_success', { count: props.onlineEmployees.length, amount: bonusAmount }))
    
    document.getElementById('bonusOnlineEmployeesAmount').value = ''
}
</script>

<template>
    <div class="modal fade" id="bonusOnlineEmployeesModal" tabindex="-1" aria-labelledby="bonusOnlineEmployeesModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h1 class="modal-title fs-5" id="bonusOnlineEmployeesModalLabel">
                        <i class="bi bi-wifi"></i> {{ $t('bonus.online_employees') }}
                    </h1>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="alert alert-warning mb-3">
                        <i class="bi bi-exclamation-triangle"></i>
                        {{ $t('bonus.online_employees_info', { count: onlineEmployees.length }) }}
                    </div>

                    <div class="online-employees-preview mb-3" v-if="onlineEmployees.length > 0">
                        <h6>{{ $t('bonus.online_employees') }}:</h6>
                        <div class="employees-list">
                            <div v-for="employee in onlineEmployees.slice(0, 3)" :key="employee.identifier" class="employee-badge d-inline-block me-2 mb-1">
                                <span class="badge">
                                    <i class="bi bi-person-circle me-1"></i>
                                    {{ employee.name }}
                                </span>
                            </div>
                            <span v-if="onlineEmployees.length > 3" class="text-muted">... +{{ onlineEmployees.length - 3 }} mehr</span>
                        </div>
                    </div>
                    
                    <div v-else class="alert alert-secondary">
                        <i class="bi bi-person-x me-2"></i>
                        {{ $t('bonus.no_online_employees') }}
                    </div>

                    <div class="input-group">
                        <span class="input-group-text">
                            <i v-if="currency === '$'" class="bi bi-currency-dollar"></i>
                            <i v-else-if="currency === '€'" class="bi bi-currency-euro"></i>
                            <i v-else-if="currency === '£'" class="bi bi-currency-pound"></i>
                            <i v-else-if="currency === '¥'" class="bi bi-currency-yen"></i>
                            <i v-else-if="currency === '₹'" class="bi bi-currency-rupee"></i>
                            <span v-else>{{ currency }}</span>
                        </span>
                        <input id="bonusOnlineEmployeesAmount" type="number" class="form-control" :placeholder="$t('bonus.bonus_amount')" aria-label="Bonus" min="1" :disabled="onlineEmployees.length === 0">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-second" data-bs-dismiss="modal">{{ $t('buttons.cancel') }}</button>
                    <button type="button" class="btn btn-main" :disabled="onlineEmployees.length === 0" data-bs-dismiss="modal" @click="giveBonusToOnlineEmployees()">
                        {{ $t('buttons.give_bonus') }}
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>

<style scoped lang="scss">
@use 'bootstrap/scss/bootstrap' as *;

.alert {
    border-radius: 8px;
    border: 1px solid var(--color-600);
    background: var(--color-750);
    color: #fff;
}

.alert-warning {
    border-color: #ffc107;
    background: rgba(255, 193, 7, 0.1);
    color: #ffc107;
}

.alert-secondary {
    border-color: var(--color-600);
    background: var(--color-750);
    color: var(--color-300);
}

.online-employees-preview {
    padding: 0.75rem;
    background: var(--color-800);
    border-radius: 8px;
    border: 1px solid var(--color-600);
}

.online-employees-preview h6 {
    color: var(--color-300);
    margin-bottom: 0.5rem;
    font-size: 0.875rem;
}

.employees-list {
    display: flex;
    flex-wrap: wrap;
    gap: 0.25rem;
}

.employee-badge .badge {
    font-size: 0.75rem;
    padding: 0.375rem 0.75rem;
    background: #28a745 !important;
}

.input-group {
    margin-bottom: 0;
}

.input-group-text {
    display: flex;
    align-items: center;
    justify-content: center;
    min-width: 45px;
}

.btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
}

* {
    outline: none !important;
    box-shadow: none !important;
}

*:focus {
    outline: none !important;
    box-shadow: none !important;
}

@media (max-width: 768px) {
    .modal-dialog {
        max-width: 95vw;
        min-width: unset;
        margin: 0.5rem;
    }
}
</style>
