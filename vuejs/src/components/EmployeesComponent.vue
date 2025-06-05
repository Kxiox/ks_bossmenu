<script setup>
    const props = defineProps({
        notifiesRef: Object,
        employees: {
            type: Array,
            default: () => []
        }
    })

    async function promote(employee) {
        try {
            const response = await fetch(`https://${GetParentResourceName()}/promoteEmployee`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8'
                },
                body: JSON.stringify({
                    employee: employee
                })
            });
            const text = await response.text();

            if (text === '"ok"') {
                props.notifiesRef?.triggerAlert('success', `Employee ${employee.firstname} ${employee.lastname} promoted successfully!`);
            } else if (text === '"self_promote"') {
                props.notifiesRef?.triggerAlert('warning', `You cannot promote yourself.`);
            } else if (text === '"highest_grade"') {
                props.notifiesRef?.triggerAlert('warning', `Employee ${employee.firstname} ${employee.lastname} is already at the highest grade.`);
            } else if (text === '"not_same_job"') {
                props.notifiesRef?.triggerAlert('warning', `Employee ${employee.firstname} ${employee.lastname} is not in the same job.`);
            } else if (text === '"error"') {
                props.notifiesRef?.triggerAlert('danger', 'An error occurred while promoting the employee.');
            } else if (text === '"unknown_error"') {
                props.notifiesRef?.triggerAlert('danger', 'An unknown error occurred while promoting the employee.');
            } else {
                props.notifiesRef?.triggerAlert('danger', 'An unexpected response was received while promoting the employee.');
            }
        } catch (error) {
            props.notifiesRef?.triggerAlert('danger', `An error occurred in NUI while promoting the employee: ${error.message}`);
        }
    }

    async function demote(employee) {
        try {
            const response = await fetch(`https://${GetParentResourceName()}/demoteEmployee`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8'
                },
                body: JSON.stringify({
                    employee: employee
                })
            });
            const text = await response.text();

            if (text === '"ok"') {
                props.notifiesRef?.triggerAlert('success', `Employee ${employee.firstname} ${employee.lastname} demoted successfully!`);
            } else if (text === '"self_demote"') {
                props.notifiesRef?.triggerAlert('warning', `You cannot demote yourself.`);
            } else if (text === '"lowest_grade"') {
                props.notifiesRef?.triggerAlert('warning', `Employee ${employee.firstname} ${employee.lastname} is already at the lowest grade.`);
            } else if (text === '"not_same_job"') {
                props.notifiesRef?.triggerAlert('warning', `Employee ${employee.firstname} ${employee.lastname} is not in the same job.`);
            } else if (text === '"error"') {
                props.notifiesRef?.triggerAlert('danger', 'An error occurred while demoting the employee.');
            } else if (text === '"unknown_error"') {
                props.notifiesRef?.triggerAlert('danger', 'An unknown error occurred while demoting the employee.');
            } else {
                props.notifiesRef?.triggerAlert('danger', 'An unexpected response was received while demoting the employee.');
            }
        } catch (error) {
            props.notifiesRef?.triggerAlert('danger', `An error occurred in NUI while demoting the employee: ${error.message}`);
        }
    }

    async function fire(employee) {
        try {
            const response = await fetch(`https://${GetParentResourceName()}/fireEmployee`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8'
                },
                body: JSON.stringify({
                    employee: employee
                })
            });
            const text = await response.text();

            if (text === '"ok"') {
                props.notifiesRef?.triggerAlert('success', `Employee ${employee.firstname} ${employee.lastname} fired successfully!`);
            } else if (text === '"self_fire"') {
                props.notifiesRef?.triggerAlert('warning', `You cannot fire yourself.`);
            } else if (text === '"not_same_job"') {
                props.notifiesRef?.triggerAlert('warning', `Employee ${employee.firstname} ${employee.lastname} is not in the same job.`);
            } else if (text === '"error"') {
                props.notifiesRef?.triggerAlert('danger', 'An error occurred while firing the employee.');
            } else if (text === '"unknown_error"') {
                props.notifiesRef?.triggerAlert('danger', 'An unknown error occurred while firing the employee.');
            } else {
                props.notifiesRef?.triggerAlert('danger', 'An unexpected response was received while firing the employee.');
            }
        } catch (error) {
            props.notifiesRef?.triggerAlert('danger', `An error occurred in NUI while firing the employee: ${error.message}`);
        }
    }
</script>

<template>
    <h1 class="text-start">{{ $t('pages.employees') }}</h1>

    <hr>

    <button class="btn btn-primary mb-3 w-100" data-bs-toggle="modal" data-bs-target="#employeeModal"><i class="bi bi-person-plus-fill"></i> {{ $t('employees.add_employee') }}</button>

    <div style="overflow-x: auto; overflow-y: auto; max-height: 36vh; max-width: 100%; min-width: 100%;">
        <table class="table table-striped table-hover">
            <thead>
                <tr>
                    <th style="font-weight: bold;">{{ $t('employees.table_name') }}</th>
                    <th style="font-weight: bold;">{{ $t('employees.table_position') }}</th>
                    <th style="font-weight: bold;">{{ $t('employees.table_salary') }}</th>
                    <th style="font-weight: bold;">{{ $t('employees.table_actions') }}</th>
                </tr>
            </thead>
            <tbody class="table-group-divider">
                <tr v-for="(employee, i) in [...employees].sort((a, b) => b.jobgradenr - a.jobgradenr)" :key="i">
                    <td>{{ employee.firstname }} {{ employee.lastname }}</td>
                    <td>{{ employee.jobgrade }}</td>
                    <td>{{ employee.salary }}</td>
                    <td class="buttons"><button class="btn btn-sm btn-primary" @click="promote(employee)">{{ $t('buttons.promote') }}</button><button class="btn btn-sm btn-primary" @click="demote(employee)">{{ $t('buttons.demote') }}</button><button class="btn btn-sm btn-danger" @click="fire(employee)">{{ $t('buttons.fire') }}</button></td>
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

    ::-webkit-scrollbar {
        width: 0.5rem;
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