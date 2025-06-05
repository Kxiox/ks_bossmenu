<script setup>
    import { defineProps } from 'vue'

    const props = defineProps({
        notifiesRef: Object,
        selectedSalary: {
            type: Object,
            default: null
        },
        currency: {
            type: String,
            default: null
        }
    })

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
                    props.notifiesRef?.triggerAlert('success', `Employee with ID ${targetId} added successfully!`);
                    document.getElementById('targetId').value = '';
                } else {
                    props.notifiesRef?.triggerAlert('danger', `Player is not online or already in this job!`);
                }
            } catch (error) {
                console.error('Error:', error);
            }
        } else {
            props.notifiesRef?.triggerAlert('warning', 'Please enter an ID over 0!');
        }
    }

    async function changeSalary() {
        const newSalary = parseInt(document.getElementById('newSalary').value);

        if (newSalary && newSalary >= 0) {
            if (newSalary === props.selectedSalary.salary) { props.notifiesRef?.triggerAlert('info', 'Salary is already set to this value!'); return; }

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
                    props.notifiesRef?.triggerAlert('success', `Salary changed to ${newSalary}${props.currency}!`);
                    document.getElementById('newSalary').value = '';
                } else {
                    props.notifiesRef?.triggerAlert('danger', `Failed to change salary!`);
                }
            } catch (error) {
                console.error('Error:', error);
            }
        } else {
            props.notifiesRef?.triggerAlert('warning', 'Please enter a valid salary!');
        }
    }
</script>

<template>
    <div class="modal fade" id="employeeModal" tabindex="-1" aria-labelledby="employeeModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h1 class="modal-title fs-5" id="employeeModalLabel"><i class="bi bi-person-plus-fill"></i> {{ $t('employees.add_employee') }}</h1>
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
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">{{ $t('buttons.cancel') }}</button>
                    <button type="button" class="btn btn-primary" data-bs-dismiss="modal"
                        @click="addEmployee()">{{ $t('buttons.add') }}</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="salaryModal" tabindex="-1" aria-labelledby="salaryModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h1 class="modal-title fs-5" id="salaryModalLabel"><i class="bi bi-cash"></i> Change Salary</h1>
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
                        <input id="newSalary" type="number" class="form-control" placeholder="Salary"
                            aria-label="Salary" min="0">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" data-bs-dismiss="modal"
                        @click="changeSalary()">Change</button>
                </div>
            </div>
        </div>
    </div>
</template>

<style scoped lang="scss">
    @use 'bootstrap/scss/bootstrap' as *;

    .modal-dialog {
        max-width: 17vw;
    }

    .modal-header {
        background-color: var(--color-900);
        color: var(--color-200);
        // border: none;
    }

    .modal-body {
        background-color: var(--color-900);
        color: white;
        // border: none;
    }

    .modal-footer {
        background-color: var(--color-900);
        color: white;
        // border: none;
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
</style>