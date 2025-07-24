<script setup>
    import { useTranslations } from '../../composables/useTranslations.js'

    const { $t } = useTranslations()

    const props = defineProps({
        notifiesRef: Object,
        currency: {
            type: String,
            default: null
        },
        employees: {
            type: Array,
            default: () => []
        }
    })

    async function giveBonusToAllEmployees() {
        const bonusAmount = parseInt(document.getElementById('bonusAllEmployeesAmount').value)
        if (!bonusAmount || bonusAmount <= 0) {
            props.notifiesRef?.triggerAlert('warning', $t('notifies.bonus.invalid_amount'))
            return
        }

        try {
            const response = await fetch(`https://${GetParentResourceName()}/giveBonusToAllEmployees`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8'
                },
                body: JSON.stringify({
                    amount: bonusAmount
                })
            });
            const text = await response.text();

            if (text === '"ok"') {
                props.notifiesRef?.triggerAlert('success', $t('notifies.bonus.all_employees_success', { count: props.employees.length, amount: bonusAmount }))
            } else {
                props.notifiesRef?.triggerAlert('danger', $t('notifies.bonus.failed'))
            }
        } catch (error) {
            props.notifiesRef?.triggerAlert('danger', $t('notifies.bonus.error', { error: error.message }))
        }

        document.getElementById('bonusAllEmployeesAmount').value = ''
    }
</script>

<template>
    <div class="modal fade" id="bonusAllEmployeesModal" tabindex="-1" aria-labelledby="bonusAllEmployeesModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h1 class="modal-title fs-5" id="bonusAllEmployeesModalLabel">
                        <i class="bi bi-people-fill"></i> {{ $t('bonus.all_employees') }}
                    </h1>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="alert alert-warning mb-3">
                        <i class="bi bi-exclamation-triangle"></i>
                        {{ $t('bonus.all_employees_info', { count: employees.length }) }}
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
                        <input id="bonusAllEmployeesAmount" type="number" class="form-control" :placeholder="$t('bonus.bonus_amount')" aria-label="Bonus" min="1">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-second" data-bs-dismiss="modal">{{ $t('buttons.cancel') }}</button>
                    <button type="button" class="btn btn-main" data-bs-dismiss="modal" @click="giveBonusToAllEmployees()">
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

    .input-group {
        margin-bottom: 0;
    }

    .input-group-text {
        display: flex;
        align-items: center;
        justify-content: center;
        min-width: 45px;
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
