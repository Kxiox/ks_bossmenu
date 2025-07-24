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
    employees: {
        type: Array,
        default: () => []
    }
})

const selectedEmployees = ref([])

function toggleEmployeeSelection(employee) {
    const index = selectedEmployees.value.findIndex(emp => emp.identifier === employee.identifier)
    
    if (index > -1) {
        selectedEmployees.value.splice(index, 1)
    } else {
        selectedEmployees.value.push(employee)
    }
}

function isEmployeeSelected(employee) {
    return selectedEmployees.value.some(emp => emp.identifier === employee.identifier)
}

function selectAllEmployees() {
    if (selectedEmployees.value.length === props.employees.length) {
        selectedEmployees.value = []
    } else {
        selectedEmployees.value = [...props.employees]
    }
}

function areAllEmployeesSelected() {
    return selectedEmployees.value.length === props.employees.length && props.employees.length > 0
}

async function giveBonusToSelectedEmployees() {
    if (selectedEmployees.value.length === 0) {
        props.notifiesRef?.triggerAlert('warning', $t('notifies.bonus.no_employees_selected'))
        return
    }
    
    try {
        const bonusAmount = parseInt(document.getElementById('bonusAmount').value)

        if (!bonusAmount || bonusAmount <= 0) {
            props.notifiesRef?.triggerAlert('warning', $t('notifies.bonus.invalid_amount'))
            return
        }

        const response = await fetch(`https://${GetParentResourceName()}/giveBonusToSelectedEmployees`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8'
            },
            body: JSON.stringify({
                employees: selectedEmployees.value,
                amount: bonusAmount
            })
        })

        const text = await response.text()

        if (text === '"ok"') {
            props.notifiesRef?.triggerAlert('success', $t('notifies.bonus.success', { count: selectedEmployees.value.length }))
        } else {
            props.notifiesRef?.triggerAlert('danger', $t('notifies.bonus.error', { error: text }))
        }
    } catch (error) {
        props.notifiesRef?.triggerAlert('danger', $t('notifies.bonus.unknown_error', { error: error.message }))
    }
    
    document.getElementById('bonusAmount').value = ''
    selectedEmployees.value = []
}
</script>

<template>
    <div class="modal fade" id="bonusEmployeesModal" tabindex="-1" aria-labelledby="bonusEmployeesModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h1 class="modal-title fs-5" id="bonusEmployeesModalLabel">
                        <i class="bi bi-person-plus-fill"></i> {{ $t('bonus.add_employee_bonus') }}
                    </h1>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="employee-selection-header mb-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="text-muted">{{ selectedEmployees.length }} / {{ employees.length }} {{ $t('employees.selected') }}</span>
                            <button type="button" class="btn btn-sm btn-outline-primary" @click="selectAllEmployees()">
                                <i class="bi" :class="areAllEmployeesSelected() ? 'bi-check-square' : 'bi-square'"></i>
                                {{ areAllEmployeesSelected() ? $t('buttons.deselect_all') : $t('buttons.select_all') }}
                            </button>
                        </div>
                    </div>

                    <div class="table-container" style="overflow-x: auto; overflow-y: auto; max-height: 30vh; max-width: 100%; min-width: 100%;">
                        <table class="table table-striped table-hover">
                            <thead>
                                <tr>
                                    <th style="font-weight: bold; width: 50px;">
                                        <input type="checkbox" class="form-check-input" :checked="areAllEmployeesSelected()" @change="selectAllEmployees()" :indeterminate="selectedEmployees.length > 0 && selectedEmployees.length < employees.length">
                                    </th>
                                    <th style="font-weight: bold;">{{ $t('employees.table_name') }}</th>
                                    <th style="font-weight: bold;">{{ $t('employees.table_grade') }}</th>
                                </tr>
                            </thead>
                            <tbody class="table-group-divider">
                                <tr v-for="(employee, i) in [...employees].sort((a, b) => b.jobgradenr - a.jobgradenr)" :key="employee.identifier || i" :class="{ 'table-active': isEmployeeSelected(employee) }" @click="toggleEmployeeSelection(employee)" style="cursor: pointer;">
                                    <td @click.stop>
                                        <input type="checkbox" class="form-check-input" :checked="isEmployeeSelected(employee)" @change="toggleEmployeeSelection(employee)">
                                    </td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="employee-avatar me-2">
                                                <i class="bi bi-person-circle"></i>
                                            </div>
                                            <div>
                                                <div class="employee-name">{{ employee.firstname }} {{ employee.lastname }}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="badge float-end">{{ employee.jobgrade || 'Unknown' }}</span>
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
                        <input id="bonusAmount" type="number" class="form-control" :placeholder="$t('bonus.bonus_amount')" aria-label="Bonus" min="1">
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-second" data-bs-dismiss="modal">{{ $t('buttons.cancel') }}</button>
                    <button type="button" class="btn btn-main" data-bs-dismiss="modal" :disabled="selectedEmployees.length === 0" @click="giveBonusToSelectedEmployees()">
                        {{ $t('buttons.give_bonus') }} ({{ selectedEmployees.length }})
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
