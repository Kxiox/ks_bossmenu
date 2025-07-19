<script setup>
    import { getCurrentInstance } from 'vue'

    const { proxy } = getCurrentInstance()
    const $t = proxy.$t

    const props = defineProps({
        notifiesRef: Object,
        selectedSalary: {
            type: Object,
            default: null
        },
        currency: {
            type: String,
            default: null
        },
        employees: {
            type: Array,
            default: () => []
        },
        saleries: {
            type: Array,
            default: () => []
        },
        onlineEmployees: {
            type: Array,
            default: () => []
        }
    })

    // Reactive state for selected employees
    const selectedEmployees = ref([])
    
    // Reactive state for selected ranks
    const selectedRanks = ref([])
    
    // Import ref from Vue
    import { ref } from 'vue'

    // Toggle employee selection
    function toggleEmployeeSelection(employee) {
        const index = selectedEmployees.value.findIndex(emp => emp.identifier === employee.identifier)
        
        if (index > -1) {
            // Employee is already selected, remove them
            selectedEmployees.value.splice(index, 1)
        } else {
            // Employee is not selected, add them
            selectedEmployees.value.push(employee)
        }
    }

    // Check if employee is selected
    function isEmployeeSelected(employee) {
        return selectedEmployees.value.some(emp => emp.identifier === employee.identifier)
    }

    // Select all employees
    function selectAllEmployees() {
        if (selectedEmployees.value.length === props.employees.length) {
            // All selected, deselect all
            selectedEmployees.value = []
        } else {
            // Not all selected, select all
            selectedEmployees.value = [...props.employees]
        }
    }

    // Check if all employees are selected
    function areAllEmployeesSelected() {
        return selectedEmployees.value.length === props.employees.length && props.employees.length > 0
    }

    // Give bonus to selected employees
    function giveBonusToSelectedEmployees() {
        if (selectedEmployees.value.length === 0) {
            props.notifiesRef?.triggerAlert('warning', $t('notifies.bonus.no_employees_selected'))
            return
        }

        // Here you can add your bonus logic
        console.log('Giving bonus to:', selectedEmployees.value)
        props.notifiesRef?.triggerAlert('success', $t('notifies.bonus.success', { count: selectedEmployees.value.length }))
        
        // Clear selections after giving bonus
        selectedEmployees.value = []
    }

        // Rank selection functions
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

    function giveBonusToSelectedRanks() {
        if (selectedRanks.value.length === 0) {
            props.notifiesRef?.triggerAlert('warning', $t('notifies.bonus.no_ranks_selected'))
            return
        }

        const bonusAmount = parseInt(document.getElementById('bonusRankAmount').value)
        if (!bonusAmount || bonusAmount <= 0) {
            props.notifiesRef?.triggerAlert('warning', $t('notifies.bonus.invalid_amount'))
            return
        }

        console.log('Giving bonus to ranks:', selectedRanks.value, 'Amount:', bonusAmount)
        props.notifiesRef?.triggerAlert('success', $t('notifies.bonus.rank_success', { count: selectedRanks.value.length, amount: bonusAmount }))
        
        selectedRanks.value = []
        document.getElementById('bonusRankAmount').value = ''
    }

    // Functions for bulk bonus modals
    function giveBonusToAllEmployees() {
        const bonusAmount = parseInt(document.getElementById('bonusAllEmployeesAmount').value)
        if (!bonusAmount || bonusAmount <= 0) {
            props.notifiesRef?.triggerAlert('warning', $t('notifies.bonus.invalid_amount'))
            return
        }

        console.log('Giving bonus to all employees:', bonusAmount)
        props.notifiesRef?.triggerAlert('success', $t('notifies.bonus.all_employees_success', { count: props.employees.length, amount: bonusAmount }))
        
        document.getElementById('bonusAllEmployeesAmount').value = ''
    }

    function giveBonusToAllRanks() {
        const bonusAmount = parseInt(document.getElementById('bonusAllRanksAmount').value)
        if (!bonusAmount || bonusAmount <= 0) {
            props.notifiesRef?.triggerAlert('warning', $t('notifies.bonus.invalid_amount'))
            return
        }

        console.log('Giving bonus to all ranks:', bonusAmount)
        props.notifiesRef?.triggerAlert('success', $t('notifies.bonus.all_ranks_success', { count: props.saleries.length, amount: bonusAmount }))
        
        document.getElementById('bonusAllRanksAmount').value = ''
    }

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

    async function addEmployee() {
        const targetId = parseInt(document.getElementById('targetId').value);

        if (targetId && targetId > 0) {
            try {
                const response = await fetch(`https://${GetParentResourceName()}/addEmployee`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json; charset=UTF-8'
                    },
                    body: JSON.stringify({
                        message: targetId
                    })
                });
                const text = await response.text();

                if (text === '"ok"') {
                    props.notifiesRef?.triggerAlert('success', $t('notifies.employees.add.success', { id: targetId }));
                } else {
                    props.notifiesRef?.triggerAlert('danger', $t('notifies.employees.add.failed'));
                }
            } catch (error) {
                props.notifiesRef?.triggerAlert('danger', $t('notifies.employees.add.nui_error', { error: error.message }));
            }
        } else {
            props.notifiesRef?.triggerAlert('warning', $t('notifies.employees.add.invalid_id'));
        }

        document.getElementById('targetId').value = '';
    }

    async function changeSalary() {
        const newSalary = parseInt(document.getElementById('newSalary').value);

        if (newSalary && newSalary >= 0) {
            if (newSalary === props.selectedSalary.salary) {
                props.notifiesRef?.triggerAlert('info', $t('notifies.salaries.change.already_set'));
                return;
            }

            try {
                const response = await fetch(`https://${GetParentResourceName()}/changeSalary`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json; charset=UTF-8'
                    },
                    body: JSON.stringify({
                        grade: props.selectedSalary.grade,
                        salary: newSalary
                    })
                });
                const text = await response.text();

                if (text === '"ok"') {
                    props.notifiesRef?.triggerAlert('success', $t('notifies.salaries.change.success', { salary: newSalary, currency: props.currency }));
                } else {
                    props.notifiesRef?.triggerAlert('danger', $t('notifies.salaries.change.failed'));
                }
            } catch (error) {
                props.notifiesRef?.triggerAlert('danger', $t('notifies.salaries.change.nui_error', { error: error.message }));
            }
        } else {
            props.notifiesRef?.triggerAlert('warning', $t('notifies.salaries.change.invalid_salary'));
        }

        document.getElementById('newSalary').value = '';
    }
</script>

<template>
    <div class="modal fade" id="employeeModal" tabindex="-1" aria-labelledby="employeeModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h1 class="modal-title fs-5" id="employeeModalLabel"><i class="bi bi-person-plus-fill"></i> {{
                        $t('employees.add_employee') }}</h1>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-person-fill"></i></span>
                        <input id="targetId" type="number" class="form-control" placeholder="ID" aria-label="ID"
                            min="1">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-second" data-bs-dismiss="modal">{{ $t('buttons.cancel')
                        }}</button>
                    <button type="button" class="btn btn-main" data-bs-dismiss="modal" @click="addEmployee()">{{
                        $t('buttons.add') }}</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="salaryModal" tabindex="-1" aria-labelledby="salaryModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h1 class="modal-title fs-5" id="salaryModalLabel"><i class="bi bi-cash"></i> {{
                        $t('salaries.change_salary') }}</h1>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="input-group">
                        <span class="input-group-text">
                            <i v-if="currency === '$'" class="bi bi-currency-dollar"></i>
                            <i v-else-if="currency === '€'" class="bi bi-currency-euro"></i>
                            <i v-else-if="currency === '£'" class="bi bi-currency-pound"></i>
                            <i v-else-if="currency === '¥'" class="bi bi-currency-yen"></i>
                            <i v-else-if="currency === '₹'" class="bi bi-currency-rupee"></i>
                            <span v-else>{{ currency }}</span></span>
                        <input id="newSalary" type="number" class="form-control"
                            :placeholder="$t('salaries.placeholder')" aria-label="Salary" min="0">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-second" data-bs-dismiss="modal">{{ $t('buttons.cancel')
                        }}</button>
                    <button type="button" class="btn btn-main" data-bs-dismiss="modal" @click="changeSalary()">{{
                        $t('buttons.change') }}</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="bonusEmployeesModal" tabindex="-1" aria-labelledby="bonusEmployeesModalLabel"
        aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h1 class="modal-title fs-5" id="bonusEmployeesModalLabel"><i class="bi bi-person-plus-fill"></i> {{
                        $t('bonus.add_employee_bonus') }}</h1>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="employee-selection-header mb-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="text-muted">{{ selectedEmployees.length }} / {{ employees.length }} {{
                                $t('employees.selected') }}</span>
                            <button type="button" class="btn btn-sm btn-outline-primary" @click="selectAllEmployees()">
                                <i class="bi" :class="areAllEmployeesSelected() ? 'bi-check-square' : 'bi-square'"></i>
                                {{ areAllEmployeesSelected() ? $t('buttons.deselect_all') : $t('buttons.select_all') }}
                            </button>
                        </div>
                    </div>

                    <div class="table-container"
                        style="overflow-x: auto; overflow-y: auto; max-height: 30vh; max-width: 100%; min-width: 100%;">
                        <table class="table table-striped table-hover">
                            <thead>
                                <tr>
                                    <th style="font-weight: bold; width: 50px;">
                                        <input type="checkbox" class="form-check-input"
                                            :checked="areAllEmployeesSelected()" @change="selectAllEmployees()"
                                            :indeterminate="selectedEmployees.length > 0 && selectedEmployees.length < employees.length">
                                    </th>
                                    <th style="font-weight: bold;">{{ $t('employees.table_name') }}</th>
                                    <th style="font-weight: bold;">{{ $t('employees.table_grade') }}</th>
                                </tr>
                            </thead>
                            <tbody class="table-group-divider">
                                <tr v-for="(employee, i) in [...employees].sort((a, b) => b.jobgradenr - a.jobgradenr)"
                                    :key="employee.identifier || i"
                                    :class="{ 'table-active': isEmployeeSelected(employee) }"
                                    @click="toggleEmployeeSelection(employee)" style="cursor: pointer;">
                                    <td @click.stop>
                                        <input type="checkbox" class="form-check-input"
                                            :checked="isEmployeeSelected(employee)"
                                            @change="toggleEmployeeSelection(employee)">
                                    </td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="employee-avatar me-2">
                                                <i class="bi bi-person-circle"></i>
                                            </div>
                                            <div>
                                                <div class="employee-name">{{ employee.firstname }} {{ employee.lastname
                                                    }}</div>
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
                        
                        <input id="bonusAmount" type="number" class="form-control":placeholder="$t('bonus.bonus_amount')" aria-label="Bonus" min="1">
                    </div>

                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-second" data-bs-dismiss="modal">{{ $t('buttons.cancel') }}</button>
                    <button type="button" class="btn btn-main" :disabled="selectedEmployees.length === 0"
                        @click="giveBonusToSelectedEmployees()">
                        {{ $t('buttons.give_bonus') }} ({{ selectedEmployees.length }})
                    </button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="bonusRanksModal" tabindex="-1" aria-labelledby="bonusRanksModalLabel"
        aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h1 class="modal-title fs-5" id="bonusRanksModalLabel"><i class="bi bi-person-plus-fill"></i> {{
                        $t('bonus.add_rank_bonus') }}</h1>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="employee-selection-header mb-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="text-muted">{{ selectedRanks.length }} / {{ saleries.length }} {{
                                $t('salaries.ranks_selected') }}</span>
                            <button type="button" class="btn btn-sm btn-outline-primary" @click="selectAllRanks()">
                                <i class="bi" :class="areAllRanksSelected() ? 'bi-check-square' : 'bi-square'"></i>
                                {{ areAllRanksSelected() ? $t('buttons.deselect_all') : $t('buttons.select_all') }}
                            </button>
                        </div>
                    </div>

                    <div class="table-container"
                        style="overflow-x: auto; overflow-y: auto; max-height: 30vh; max-width: 100%; min-width: 100%;">
                        <table class="table table-striped table-hover">
                            <thead>
                                <tr>
                                    <th style="font-weight: bold; width: 50px;">
                                        <input type="checkbox" class="form-check-input"
                                            :checked="areAllRanksSelected()" @change="selectAllRanks()"
                                            :indeterminate="selectedRanks.length > 0 && selectedRanks.length < saleries.length">
                                    </th>
                                    <th style="font-weight: bold;">{{ $t('salaries.table_name') }}</th>
                                </tr>
                            </thead>
                            <tbody class="table-group-divider">
                                <tr v-for="(rank, i) in [...saleries].sort((a, b) => b.grade - a.grade)"
                                    :key="rank.grade || i"
                                    :class="{ 'table-active': isRankSelected(rank) }"
                                    @click="toggleRankSelection(rank)" style="cursor: pointer;">
                                    <td @click.stop>
                                        <input type="checkbox" class="form-check-input"
                                            :checked="isRankSelected(rank)"
                                            @change="toggleRankSelection(rank)">
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
                    <button type="button" class="btn btn-main" :disabled="selectedRanks.length === 0"
                        @click="giveBonusToSelectedRanks()">
                        {{ $t('buttons.give_bonus') }} ({{ selectedRanks.length }})
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Bonus All Employees Modal -->
    <div class="modal fade" id="bonusAllEmployeesModal" tabindex="-1" aria-labelledby="bonusAllEmployeesModalLabel"
        aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h1 class="modal-title fs-5" id="bonusAllEmployeesModalLabel"><i class="bi bi-people-fill"></i> {{
                        $t('bonus.add_employee_bonus') }}</h1>
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

    <!-- Bonus All Ranks Modal -->
    <div class="modal fade" id="bonusAllRanksModal" tabindex="-1" aria-labelledby="bonusAllRanksModalLabel"
        aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h1 class="modal-title fs-5" id="bonusAllRanksModalLabel"><i class="bi bi-award-fill"></i> {{
                        $t('bonus.add_rank_bonus') }}</h1>
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

    <!-- Bonus Online Employees Modal -->
    <div class="modal fade" id="bonusOnlineEmployeesModal" tabindex="-1" aria-labelledby="bonusOnlineEmployeesModalLabel"
        aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h1 class="modal-title fs-5" id="bonusOnlineEmployeesModalLabel"><i class="bi bi-person-check-fill"></i> {{
                        $t('bonus.online_employees') }}</h1>
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

    /* Ensure input groups work properly in modals */
    .input-group {
        margin-bottom: 0;
    }

    .input-group-text {
        display: flex;
        align-items: center;
        justify-content: center;
        min-width: 45px;
    }

    /* Remove all focus outlines and blue borders */
    * {
        outline: none !important;
        box-shadow: none !important;
    }

    *:focus {
        outline: none !important;
        box-shadow: none !important;
    }

    input:focus,
    textarea:focus,
    select:focus,
    button:focus {
        outline: none !important;
        box-shadow: none !important;
    }

    /* Mobile responsiveness */
    @media (max-width: 768px) {
        .modal-dialog {
            max-width: 95vw;
            min-width: unset;
            margin: 0.5rem;
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

    table {
        .buttons {
            display: flex;
            gap: 10px;
        }
    }

    /* Employee Selection Styles */
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

    /* Custom Scrollbar für die Bonus-Tabelle */
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

    .table-container::-webkit-scrollbar-corner {
        background: var(--color-800);
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

    .table tr.table-active:hover {
        background: var(--color-700) !important;
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

    .form-check-input:focus {
        border-color: var(--color-500) !important;
        box-shadow: 0 0 0 0.2rem rgba(0, 0, 0, 0.25) !important;
    }

    .form-check-input:indeterminate {
        background-color: var(--color-600) !important;
        border-color: var(--color-500) !important;
    }

    .btn:disabled {
        opacity: 0.5;
        cursor: not-allowed;
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

    .bg-secondary {
        background: linear-gradient(135deg, 
            var(--color-600) 0%, 
            var(--color-500) 100%) !important;
    }

    /* Bulk Bonus Modal Styles */
    .alert {
        border-radius: 8px;
        border: 1px solid var(--color-600);
        background: var(--color-750);
        color: #fff;
    }

    .alert-info {
        border-color: #17a2b8;
        background: rgba(23, 162, 184, 0.1);
        color: #17a2b8;
    }

    .alert-warning {
        border-color: #ffc107;
        background: rgba(255, 193, 7, 0.1);
        color: #ffc107;
    }

    .alert-success {
        border-color: #28a745;
        background: rgba(40, 167, 69, 0.1);
        color: #28a745;
    }

    .alert-secondary {
        border-color: var(--color-600);
        background: var(--color-750);
        color: var(--color-300);
    }

    .ranks-preview, .online-employees-preview {
        padding: 0.75rem;
        background: var(--color-800);
        border-radius: 8px;
        border: 1px solid var(--color-600);
    }

    .ranks-preview h6, .online-employees-preview h6 {
        color: var(--color-300);
        margin-bottom: 0.5rem;
        font-size: 0.875rem;
    }

    .ranks-list, .employees-list {
        display: flex;
        flex-wrap: wrap;
        gap: 0.25rem;
    }

    .employee-badge .badge {
        font-size: 0.75rem;
        padding: 0.375rem 0.75rem;
    }

    .badge.bg-success {
        background: #28a745 !important;
    }

    .badge.bg-secondary {
        background: var(--color-600) !important;
    }
</style>