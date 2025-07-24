<script setup>
import { ref } from 'vue'
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

const selectedRanks = ref([])

function toggleRankSelection(rank) {
    const index = selectedRanks.value.findIndex(r => r.grade === rank.grade)
    
    if (index > -1) {
        selectedRanks.value.splice(index, 1)
    } else {
        selectedRanks.value.push(rank)
    }
}

function isRankSelected(rank) {
    return selectedRanks.value.some(r => r.grade === rank.grade)
}

function selectAllRanks() {
    if (selectedRanks.value.length === props.saleries.length) {
        selectedRanks.value = []
    } else {
        selectedRanks.value = [...props.saleries]
    }
}

function areAllRanksSelected() {
    return selectedRanks.value.length === props.saleries.length && props.saleries.length > 0
}

async function giveBonusToSelectedRanks() {
    if (selectedRanks.value.length === 0) {
        props.notifiesRef?.triggerAlert('warning', $t('notifies.bonus.no_ranks_selected'))
        return
    }

    try {
        const bonusAmount = parseInt(document.getElementById('bonusRankAmount').value)
        if (!bonusAmount || bonusAmount <= 0) {
            props.notifiesRef?.triggerAlert('warning', $t('notifies.bonus.invalid_amount'))
            return
        }

        const response = await fetch(`https://${GetParentResourceName()}/giveBonusToRanks`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8'
            },
            body: JSON.stringify({
                ranks: selectedRanks.value,
                amount: bonusAmount
            })
        })

        const text = await response.text()
        if (text === '"ok"') {
            props.notifiesRef?.triggerAlert('success', $t('notifies.bonus.ranks_success', { count: selectedRanks.value.length, amount: bonusAmount }))
        } else {
            props.notifiesRef?.triggerAlert('danger', $t('notifies.bonus.failed'))
        }
    } catch (error) {
        props.notifiesRef?.triggerAlert('danger', $t('notifies.bonus.nui_error', { error: error.message }))
    }

    document.getElementById('bonusRankAmount').value = ''
    selectedRanks.value = []
}
</script>

<template>
    <div class="modal fade" id="bonusRanksModal" tabindex="-1" aria-labelledby="bonusRanksModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h1 class="modal-title fs-5" id="bonusRanksModalLabel">
                        <i class="bi bi-award-fill"></i> {{ $t('bonus.add_rank_bonus') }}
                    </h1>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="employee-selection-header mb-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="text-muted">{{ selectedRanks.length }} / {{ saleries.length }} {{ $t('salaries.ranks_selected') }}</span>
                            <button type="button" class="btn btn-sm btn-outline-primary" @click="selectAllRanks()">
                                <i class="bi" :class="areAllRanksSelected() ? 'bi-check-square' : 'bi-square'"></i>
                                {{ areAllRanksSelected() ? $t('buttons.deselect_all') : $t('buttons.select_all') }}
                            </button>
                        </div>
                    </div>

                    <div class="table-container" style="overflow-x: auto; overflow-y: auto; max-height: 30vh; max-width: 100%; min-width: 100%;">
                        <table class="table table-striped table-hover">
                            <thead>
                                <tr>
                                    <th style="font-weight: bold; width: 50px;">
                                        <input type="checkbox" class="form-check-input" :checked="areAllRanksSelected()" @change="selectAllRanks()" :indeterminate="selectedRanks.length > 0 && selectedRanks.length < saleries.length">
                                    </th>
                                    <th style="font-weight: bold;">{{ $t('salaries.table_name') }}</th>
                                </tr>
                            </thead>
                            <tbody class="table-group-divider">
                                <tr v-for="(rank, i) in [...saleries].sort((a, b) => b.grade - a.grade)" :key="rank.grade || i" :class="{ 'table-active': isRankSelected(rank) }" @click="toggleRankSelection(rank)" style="cursor: pointer;">
                                    <td @click.stop>
                                        <input type="checkbox" class="form-check-input" :checked="isRankSelected(rank)" @change="toggleRankSelection(rank)">
                                    </td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="employee-avatar me-2">
                                                <i class="bi bi-award-fill"></i>
                                            </div>
                                            <div>
                                                <div class="employee-name">{{ rank.gradename || `${rank.grade_label}` }}</div>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="input-group mt-3">
                        <span class="input-group-text">
                            <i v-if="currency === '$'" class="bi bi-currency-dollar"></i>
                            <i v-else-if="currency === '€'" class="bi bi-currency-euro"></i>
                            <i v-else-if="currency === '£'" class="bi bi-currency-pound"></i>
                            <i v-else-if="currency === '¥'" class="bi bi-currency-yen"></i>
                            <i v-else-if="currency === '₹'" class="bi bi-currency-rupee"></i>
                            <span v-else>{{ currency }}</span>
                        </span>
                        <input id="bonusRankAmount" type="number" class="form-control" :placeholder="$t('bonus.bonus_amount')" aria-label="Bonus" min="1">
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-second" data-bs-dismiss="modal">{{ $t('buttons.cancel') }}</button>
                    <button type="button" class="btn btn-main" data-bs-dismiss="modal" :disabled="selectedRanks.length === 0" @click="giveBonusToSelectedRanks()">
                        {{ $t('buttons.give_bonus') }} ({{ selectedRanks.length }})
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>

<style scoped lang="scss">
@use 'bootstrap/scss/bootstrap' as *;

.employee-selection-header {
    padding: 0.75rem;
    background: var(--color-750);
    border-radius: 8px;
    border: 1px solid var(--color-600);
}

.employee-avatar {
    font-size: 1.5rem;
    color: var(--color-400);
}

.employee-name {
    font-weight: 600;
    color: #fff;
}

.table-container {
    border-radius: 8px;
    border: 1px solid var(--color-600);
    background: var(--color-800);
    overflow-x: auto !important;
    overflow-y: auto !important;
}

.table-container::-webkit-scrollbar {
    width: 8px;
    height: 8px;
}

.table-container::-webkit-scrollbar-track {
    background: var(--color-800);
    border-radius: 4px;
}

.table-container::-webkit-scrollbar-thumb {
    background: var(--color-600);
    border-radius: 4px;
    transition: background 0.2s ease;
}

.table-container::-webkit-scrollbar-thumb:hover {
    background: var(--color-500);
}

.table tr {
    transition: all 0.2s ease;
}

.table tr:hover {
    background: var(--color-700) !important;
}

.table tr.table-active {
    border-left: 3px solid var(--color-500);
}

.table th {
    background: var(--color-700) !important;
    color: #fff !important;
    border-bottom: 2px solid var(--color-600) !important;
    position: sticky;
    top: 0;
    z-index: 10;
}

.table td {
    border-bottom: 1px solid var(--color-700) !important;
    color: #fff !important;
    vertical-align: middle;
}

.form-check-input {
    background-color: var(--color-800) !important;
    border: 1px solid var(--color-600) !important;
    border-radius: 4px !important;
    width: 1.2rem !important;
    height: 1.2rem !important;
    cursor: pointer !important;
}

.form-check-input:checked {
    background-color: var(--color-500) !important;
    border-color: var(--color-400) !important;
}

.btn-outline-primary {
    border-color: var(--color-600) !important;
    color: var(--color-300) !important;
    background: transparent !important;
}

.btn-outline-primary:hover {
    background: var(--color-600) !important;
    border-color: var(--color-500) !important;
    color: #fff !important;
}

.badge {
    font-size: 0.75rem;
    padding: 0.375rem 0.75rem;
    border-radius: 6px;
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
