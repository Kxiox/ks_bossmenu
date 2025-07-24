<script setup>
    import { useTranslations } from '../composables/useTranslations.js'

    const { $t } = useTranslations()
    
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
                props.notifiesRef?.triggerAlert('success', $t('notifies.employees.promote.success', { name: `${employee.firstname} ${employee.lastname}` }));
            } else if (text === '"self_promote"') {
                props.notifiesRef?.triggerAlert('warning', $t('notifies.employees.promote.self_promote'));
            } else if (text === '"highest_grade"') {
                props.notifiesRef?.triggerAlert('warning', $t('notifies.employees.promote.highest_grade', { name: `${employee.firstname} ${employee.lastname}` }));
            } else if (text === '"not_same_job"') {
                props.notifiesRef?.triggerAlert('warning', $t('notifies.employees.promote.not_same_job', { name: `${employee.firstname} ${employee.lastname}` }));
            } else if (text === '"error"') {
                props.notifiesRef?.triggerAlert('danger', $t('notifies.employees.promote.error'));
            } else if (text === '"unknown_error"') {
                props.notifiesRef?.triggerAlert('danger', $t('notifies.employees.promote.unknown_error'));
            } else {
                props.notifiesRef?.triggerAlert('danger', $t('notifies.employees.promote.unknown'));
            }
        } catch (error) {
            props.notifiesRef?.triggerAlert('danger', $t('notifies.employees.promote.nui_error', { error: error.message }));
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
                props.notifiesRef?.triggerAlert('success', $t('notifies.employees.demote.success', { name: `${employee.firstname} ${employee.lastname}` }));
            } else if (text === '"self_demote"') {
                props.notifiesRef?.triggerAlert('warning', $t('notifies.employees.demote.self_demote'));
            } else if (text === '"lowest_grade"') {
                props.notifiesRef?.triggerAlert('warning', $t('notifies.employees.demote.lowest_grade', { name: `${employee.firstname} ${employee.lastname}` }));
            } else if (text === '"not_same_job"') {
                props.notifiesRef?.triggerAlert('warning', $t('notifies.employees.demote.not_same_job', { name: `${employee.firstname} ${employee.lastname}` }));
            } else if (text === '"error"') {
                props.notifiesRef?.triggerAlert('danger', $t('notifies.employees.demote.error'));
            } else if (text === '"unknown_error"') {
                props.notifiesRef?.triggerAlert('danger', $t('notifies.employees.demote.unknown_error'));
            } else {
                props.notifiesRef?.triggerAlert('danger', $t('notifies.employees.demote.unknown'));
            }
        } catch (error) {
            props.notifiesRef?.triggerAlert('danger', $t('notifies.employees.demote.nui_error', { error: error.message }));
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
                props.notifiesRef?.triggerAlert('success', $t('notifies.employees.fire.success', { name: `${employee.firstname} ${employee.lastname}` }));
            } else if (text === '"self_fire"') {
                props.notifiesRef?.triggerAlert('warning', $t('notifies.employees.fire.self_fire'));
            } else if (text === '"not_same_job"') {
                props.notifiesRef?.triggerAlert('warning', $t('notifies.employees.fire.not_same_job', { name: `${employee.firstname} ${employee.lastname}` }));
            } else if (text === '"error"') {
                props.notifiesRef?.triggerAlert('danger', $t('notifies.employees.fire.error'));
            } else if (text === '"unknown_error"') {
                props.notifiesRef?.triggerAlert('danger', $t('notifies.employees.fire.unknown_error'));
            } else {
                props.notifiesRef?.triggerAlert('danger', $t('notifies.employees.fire.unknown'));
            }
        } catch (error) {
            props.notifiesRef?.triggerAlert('danger', $t('notifies.employees.fire.nui_error', { error: error.message }));
        }
    }
</script>

<template>
    <h1 class="text-start">{{ $t('pages.employees') }}</h1>

    <hr>

    <button class="btn btn-main mb-3 w-100" data-bs-toggle="modal" data-bs-target="#employeeModal"><i class="bi bi-person-plus-fill"></i> {{ $t('employees.add_employee') }}</button>

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
                    <td class="buttons"><button class="btn btn-sm btn-main" @click="promote(employee)">{{ $t('buttons.promote') }}</button><button class="btn btn-sm btn-main" @click="demote(employee)">{{ $t('buttons.demote') }}</button><button class="btn btn-sm btn-red" @click="fire(employee)">{{ $t('buttons.fire') }}</button></td>
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
</style>