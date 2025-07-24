<script setup>
import { useTranslations } from '../../composables/useTranslations.js'

const { $t } = useTranslations()

const props = defineProps({
    notifiesRef: Object,
    currency: {
        type: String,
        default: null
    },
    saleries: {
        type: Array,
        default: () => []
    }
})

async function giveBonusToAllRanks() {
    const bonusAmount = parseInt(document.getElementById('bonusAllRanksAmount').value)
    if (!bonusAmount || bonusAmount <= 0) {
        props.notifiesRef?.triggerAlert('warning', $t('notifies.bonus.invalid_amount'))
        return
    }

    try {
        const response = await fetch(`https://${GetParentResourceName()}/giveBonusToAllRanks`, {
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
            props.notifiesRef?.triggerAlert('success', $t('notifies.bonus.all_ranks_success', { count: props.saleries.length, amount: bonusAmount }))
        } else {
            props.notifiesRef?.triggerAlert('danger', $t('notifies.bonus.failed'))
        }
    } catch (error) {
        props.notifiesRef?.triggerAlert('danger', $t('notifies.bonus.error', { error: error.message }))
    }

    document.getElementById('bonusAllRanksAmount').value = ''
}
</script>

<template>
    <div class="modal fade" id="bonusAllRanksModal" tabindex="-1" aria-labelledby="bonusAllRanksModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h1 class="modal-title fs-5" id="bonusAllRanksModalLabel">
                        <i class="bi bi-diagram-2-fill"></i> {{ $t('bonus.all_ranks') }}
                    </h1>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="alert alert-warning mb-3">
                        <i class="bi bi-exclamation-triangle"></i>
                        {{ $t('bonus.all_ranks_info', { count: saleries.length }) }}
                    </div>

                    <div class="ranks-preview mb-3">
                        <h6>{{ $t('bonus.affected_ranks') }}:</h6>
                        <div class="ranks-list">
                            <span v-for="rank in saleries.slice(0, 5)" :key="rank.grade" class="badge bg-secondary me-1 mb-1">
                                {{ rank.grade_label || `Grade ${rank.grade}` }}
                            </span>
                            <span v-if="saleries.length > 5" class="text-muted">... +{{ saleries.length - 5 }} mehr</span>
                        </div>
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
                        <input id="bonusAllRanksAmount" type="number" class="form-control" :placeholder="$t('bonus.bonus_amount')" aria-label="Bonus" min="1">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-second" data-bs-dismiss="modal">{{ $t('buttons.cancel') }}</button>
                    <button type="button" class="btn btn-main" data-bs-dismiss="modal" @click="giveBonusToAllRanks()">
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

.ranks-preview {
    padding: 0.75rem;
    background: var(--color-800);
    border-radius: 8px;
    border: 1px solid var(--color-600);
}

.ranks-preview h6 {
    color: var(--color-300);
    margin-bottom: 0.5rem;
    font-size: 0.875rem;
}

.ranks-list {
    display: flex;
    flex-wrap: wrap;
    gap: 0.25rem;
}

.badge.bg-secondary {
    background: var(--color-600) !important;
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
